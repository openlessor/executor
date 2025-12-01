import express from "express";
import compression from "compression";
import { readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import { createServer as createViteServer } from "vite";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const resolve = (...segments) => path.resolve(__dirname, ...segments);

const HTML_PLACEHOLDER = "<!--app-html-->";
const PORT = Number(process.env.PORT) || 5173;
const HOST = process.env.HOST || "0.0.0.0";
const IS_PROD = process.env.NODE_ENV === "production";

async function createServer() {
  const app = express();
  app.use(compression());

  if (IS_PROD) {
    const clientDist = resolve("dist", "client");
    const serverEntry = resolve("dist", "server", "EntryServer.mjs");
    const templateHtml = await readFile(
      path.join(clientDist, "index.html"),
      "utf-8",
    );
    const { render } = await import(pathToFileURL(serverEntry).href);

    app.use(
      "/assets",
      express.static(path.join(clientDist, "assets"), {
        immutable: true,
        maxAge: "1y",
      }),
    );
    app.use(express.static(clientDist, { index: false }));

    app.use("*b", async (req, res) => {
      try {
        const url = req.originalUrl || req.url || "/";
        const { html: appHtml, executorConfig } = await render(url);
        const stateJson = JSON.stringify(executorConfig);
        const html = templateHtml
          .replace(HTML_PLACEHOLDER, appHtml)
          .replace(
            "</body>",
            `<script>window.__EXECUTOR_CONFIG__=${stateJson};</script></body>`,
          );
        res.status(200).set({ "Content-Type": "text/html" }).end(html);
      } catch (error) {
        console.error("[ssr]", error);
        res.status(500).end("Internal Server Error");
      }
    });
  } else {
    const vite = await createViteServer({
      root: __dirname,
      server: { middlewareMode: true },
      appType: "custom",
    });

    app.use(vite.middlewares);

    app.use("*b", async (req, res) => {
      try {
        const url = req.originalUrl || req.url || "/";
        let template = await readFile(resolve("index.html"), "utf-8");
        template = await vite.transformIndexHtml(url, template);

        const { render } = await vite.ssrLoadModule("/src/EntryServer.mjs");
        const { html: appHtml, executorConfig } = await render(url);
        const stateJson = JSON.stringify(executorConfig);
        console.log(
          `<script>window.__EXECUTOR_CONFIG__=${stateJson};</script></body>`,
        );
        const html = template
          .replace(HTML_PLACEHOLDER, appHtml)
          .replace(
            "</body>",
            `<script>window.__EXECUTOR_CONFIG__=${stateJson};</script></body>`,
          );

        res.status(200).set({ "Content-Type": "text/html" }).end(html);
      } catch (error) {
        vite.ssrFixStacktrace(error);
        console.error("[vite][ssr]", error);
        res.status(500).end(error.stack);
      }
    });
  }

  return app;
}

createServer()
  .then((app) => {
    app.listen(PORT, HOST, () => {
      console.log(
        `➜  SSR server ready on http://${HOST}:${PORT} (${IS_PROD ? "prod" : "dev"})`,
      );
    });
  })
  .catch((error) => {
    console.error("Failed to start SSR server:", error);
    process.exit(1);
  });
