import tailwind from "bun-plugin-tailwind";

// Plugin to force React resolution to the project root
// This prevents duplicate React instances when using linked packages (like tilia)
const resolveReactToRoot = {
  name: "resolve-react-to-root",
  setup(build) {
    // Match react, react-dom, and their subpaths (like react/jsx-runtime)
    build.onResolve({ filter: /^react(-dom)?/ }, async (args) => {
      // Resolve relative to the current working directory (project root)
      const resolved = await Bun.resolve(args.path, process.cwd());
      return {
        path: resolved,
      };
    });
  },
};

console.log("Building client...");
await Bun.build({
  publicPath: `${process.env.API_BASE_URL}/`,
  plugins: [tailwind, resolveReactToRoot],
  entrypoints: ["./executor-ui/index.html", "./executor-ui/src/Index.mjs"],
  outdir: "../public",
  env: "inline",
});

console.log("Building server...");
await Bun.build({
  target: "bun",
  plugins: [resolveReactToRoot],
  entrypoints: ["./executor/src/Server.mjs"],
  outdir: "./dist",
});
