module Route = {
  module Frontend = {
    let get = Bun.Handler(
      async (_req: Bun.BunRequest.t, _) => {
        Response.make("hello")
      },
    )
    let handler: Bun.routeHandlerObject = {get: get}
  }
  module Config = {
    type output = {
      inventory: array<Inventory__sql.query1Result>,
      premise: Nullable.t<Premise__sql.query1Result>,
    }
    let get = Bun.Handler(
      async (req: Bun.BunRequest.t, _) => {
        let headers = Headers.make()
        headers->Headers.set("content-type", "application/json")
        let response: output = await Connection.withClient(async client => {
          let premise_id: string =
            req->Bun.BunRequest.params->Dict.get("premise_id")->Option.getUnsafe
          let premise = await Premise.getPremise(~client, premise_id)
          let inventory = await Inventory.getInventoryList(~client, premise_id)
          {inventory, premise}
        })
        Response.makeWithJsonUnsafe(response, ~options={headers, status: 200})
      },
    )
    let handler: Bun.routeHandlerObject = {get: get}
  }
  module Inventory = {
    let post = Bun.Handler(
      async (req: Bun.BunRequest.t, _) => {
        let premise_id: string =
          req->Bun.BunRequest.params->Dict.get("premise_id")->Option.getUnsafe
        await Connection.withClient(async client => {
          await MockData.createMockData(~client, premise_id)
        })
        Response.make("")
      },
    )
    let handler: Bun.routeHandlerObject = {post: post}
  }
}

let server = Bun.serve({
  port: 8899,
  routes: Dict.fromArray([
    ("/", Route.Frontend.handler),
    ("/config/:premise_id", Route.Config.handler),
    ("/inventory/:premise_id", Route.Inventory.handler),
  ]),
  fetch: async (_, _) => {
    Response.make("Not Found")
  },
})

let port =
  server
  ->Bun.Server.port
  ->Int.toString

let hostName = server->Bun.Server.hostname

Console.log(`Server listening on http://${hostName}:${port}!`)
