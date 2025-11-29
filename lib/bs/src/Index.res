let server = Bun.serve({
  port: 0,
  fetch: async (_request, _server) => {
    let inventory = await Inventory.getInventoryList()
    let headers = HeadersInit.FromDict(dict{"content-type": "application/json"})
    let body = switch JSON.stringifyAny(inventory) {
    | Some(jsonString) => jsonString
    | None => "[]"
    }
    Response.make(body, ~options={headers, status: 200})
  },
})

let port =
  server
  ->Bun.Server.port
  ->Int.toString

let hostName = server->Bun.Server.hostname

Console.log(`Server listening on http://${hostName}:${port}!`)
