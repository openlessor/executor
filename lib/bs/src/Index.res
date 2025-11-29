module Route = {
  module Config = {
    type output = {
      inventory: array<Inventory__sql.query1Result>,
      tenant: Nullable.t<Tenant__sql.query1Result>,
    }
    let get = Bun.Handler(
      async (req: Bun.BunRequest.t, _) => {
        let headers = Headers.make()
        headers->Headers.set("content-type", "application/json")
        let response: output = await Connection.withClient(async client => {
          let tenantId: string = req->Bun.BunRequest.params->Dict.get("tenant")->Option.getUnsafe
          let tenant = await Tenant.getTenant(~client, tenantId)
          let inventory = await Inventory.getInventoryList(~client, tenantId)
          {inventory, tenant}
        })
        Response.makeWithJsonUnsafe(response, ~options={headers, status: 200})
      },
    )
    let handler: Bun.routeHandlerObject = {get: get}
  }
}

let server = Bun.serve({
  port: 8899,
  routes: Dict.fromArray([("/config/:tenant", Route.Config.handler)]),
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
