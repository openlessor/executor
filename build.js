import tailwind from "bun-plugin-tailwind";
await Bun.build({
  publicPath: `${process.env.API_BASE_URL}/`,
  plugins: [tailwind],
  entrypoints: ["./executor-ui/index.html", "./executor-ui/src/Index.mjs"],
  outdir: "../public",
  env: "inline",
});
await Bun.build({
  target: "bun",
  entrypoints: ["./executor/src/EntryServer.mjs", "./executor/src/Server.mjs"],
});
