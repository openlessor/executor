await Bun.build({
  entrypoints: ["./index.html", "./src/Index.mjs"],
  outdir: "./public",
  env: "inline"
});
