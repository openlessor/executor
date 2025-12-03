await Bun.build({
  target: "bun",
  entrypoints: ["./src/EntryServer.mjs", "./src/Server.mjs"],
});
