import tailwind from "bun-plugin-tailwind";
await Bun.build({
  publicPath: `${process.env.API_BASE_URL}/`,
  plugins: [tailwind],
  entrypoints: ["./index.html", "./client/src/Index.mjs"],
  outdir: "./public",
  env: "inline",
});
await Bun.build({
  target: "bun",
  entrypoints: ["./server/src/EntryServer.mjs", "./server/src/Server.mjs"],
});
