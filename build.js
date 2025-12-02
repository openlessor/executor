import tailwind from "bun-plugin-tailwind";
await Bun.build({
  publicPath: `${process.env.API_BASE_URL}/`,
  plugins: [tailwind],
  entrypoints: ["./index.html", "./src/Index.mjs"],
  outdir: "./public",
  env: "inline",
});
