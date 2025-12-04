import { spawn } from "child_process";
import {
  watch,
  existsSync,
  rmSync,
  symlinkSync,
  realpathSync,
  mkdirSync,
  readFileSync,
  writeFileSync,
} from "fs";
import { join, resolve } from "path";
import tailwind from "bun-plugin-tailwind";

// --- LiveReload Server ---
const LIVERELOAD_PORT = 35729;
const clients = new Set();

Bun.serve({
  port: LIVERELOAD_PORT,
  fetch(req, server) {
    if (server.upgrade(req)) {
      return;
    }
    return new Response("LiveReload Server");
  },
  websocket: {
    open(ws) {
      clients.add(ws);
    },
    close(ws) {
      clients.delete(ws);
    },
    message(ws, message) {},
  },
});

function notifyClients() {
  console.log("🔄 Reloading clients...");
  for (const ws of clients) {
    ws.send("reload");
  }
}

// --- 1. Fix React Resolution (The "Symlink Hack") ---
// This forces the linked 'tilia' package to use the host's React instance
// by physically replacing its local react/react-dom with symlinks to the root.
// This allows us to run the server natively (no bundling) while avoiding "Invalid Hook Call".

function fixReactResolution() {
  console.log("🔧 Fixing React resolution for linked packages...");

  const rootNodeModules = resolve(process.cwd(), "node_modules");
  const tiliaPath = resolve(rootNodeModules, "tilia");

  if (!existsSync(tiliaPath)) {
    console.warn(
      "⚠️  'tilia' package not found in node_modules. Skipping fix.",
    );
    return;
  }

  // Resolve the real path (since it's a symlink)
  const realTiliaPath = realpathSync(tiliaPath);
  const tiliaNodeModules = join(realTiliaPath, "node_modules");

  if (!existsSync(tiliaNodeModules)) {
    mkdirSync(tiliaNodeModules, { recursive: true });
  }

  const packagesToFix = ["react", "react-dom"];

  packagesToFix.forEach((pkg) => {
    const rootPkg = join(rootNodeModules, pkg);
    const targetPkg = join(tiliaNodeModules, pkg);

    if (!existsSync(rootPkg)) {
      console.error(`❌ Could not find ${pkg} in root node_modules.`);
      return;
    }

    try {
      // Remove existing directory/symlink in tilia
      if (existsSync(targetPkg)) {
        rmSync(targetPkg, { recursive: true, force: true });
      }

      // Create symlink pointing back to root
      symlinkSync(rootPkg, targetPkg, "dir");
      console.log(`   Linked ${pkg} in tilia -> root`);
    } catch (e) {
      console.error(`   Failed to link ${pkg}:`, e.message);
    }
  });
}

// --- 2. Client Builder ---

async function buildClient() {
  const time = new Date().toLocaleTimeString();
  console.log(`[${time}] 🏗️  Building Client...`);
  try {
    await Bun.build({
      publicPath: `${process.env.API_BASE_URL}/`,
      plugins: [tailwind],
      entrypoints: ["./executor-ui/index.html", "./executor-ui/src/Index.mjs"],
      outdir: "../public",
      env: "inline",
    });

    // Inject LiveReload script into index.html
    const htmlPath = "../public/index.html";
    if (existsSync(htmlPath)) {
      let html = readFileSync(htmlPath, "utf8");
      const script = `
      <script>
        (function() {
          var socket = new WebSocket("ws://localhost:${LIVERELOAD_PORT}");
          socket.onmessage = function(msg) {
            if (msg.data === "reload") window.location.reload();
          };
          console.log('LiveReload connected');
        })();
      </script>
      `;

      if (!html.includes(`ws://localhost:${LIVERELOAD_PORT}`)) {
        html = html.replace("</body>", script + "</body>");
        writeFileSync(htmlPath, html);
      }
    }

    console.log(`[${time}] ✅ Client Build Complete`);
    notifyClients();
  } catch (e) {
    console.error(`[${time}] ❌ Client Build Failed:`, e);
  }
}

// --- 3. Main Execution ---

// Apply the fix immediately
fixReactResolution();

// Initial Client Build
await buildClient();

// Watch Client Source for Rebuilds
console.log("👀 Watching client sources...");
const clientWatchDirs = ["./executor-ui/src", "./common"];
let debounceTimer;

clientWatchDirs.forEach((dir) => {
  if (existsSync(dir)) {
    watch(dir, { recursive: true }, (event, filename) => {
      if (
        filename &&
        (filename.endsWith(".mjs") ||
          filename.endsWith(".css") ||
          filename.endsWith(".html"))
      ) {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(buildClient, 100);
      }
    });
  }
});

// --- 4. Start Server (Native Bun Watch) ---

console.log("🚀 Starting Server with 'bun --watch'...");
// We use --watch to let Bun handle hot reloading of the server process natively
const serverProc = spawn("bun", ["--watch", "executor/src/Server.mjs"], {
  stdio: "inherit",
  env: { ...process.env },
});

serverProc.on("close", (code) => {
  console.log(`Server process exited with code ${code}`);
  process.exit(code);
});
