await Bun.build({
  entrypoints: ["./index.html"],
  outdir: "./public",
  env: "inline",
  target: "browser"
});
