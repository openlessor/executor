type renderResult = {executorConfig: ExecutorUi.Config.t, html: string}

let render = (url: string): promise<renderResult> => {
  let app_url = RescriptReactRouter.dangerouslyGetInitialUrl(~serverUrlString=url, ())
  let requested_root = app_url.path->List.head->Option.getOr("/")
  let is_child_route = Common.Constants.premise_routes->List.has(requested_root, (a, b) => a == b)
  Console.log(is_child_route)
  let route_root = if is_child_route || app_url.path->Belt.List.length == 0 {
    "/"
  } else {
    "/" ++ app_url.path->Belt.List.head->Option.getUnsafe
  }
  Console.log("root route:" ++ route_root)

  Connection.withClient(client =>
    Route.getMatchingPremise(~client, route_root)->Promise.then(premise =>
      Inventory.getInventoryList(
        ~client,
        premise->Option.map(p => p.id)->Option.getOr(""),
      )->Promise.then(
        inventoryRows => {
          let inventory: array<ExecutorUi.InventoryItem.t> = Belt.Array.map(
            inventoryRows,
            Inventory.toInventoryItem,
          )
          let config: ExecutorUi.Config.t = {
            inventory,
            premise: Some({
              id: premise->Option.map(p => p.id)->Option.getOr(""),
              name: premise->Option.map(p => p.name)->Option.getOr(""),
              description: premise->Option.map(p => p.description)->Option.getOr(""),
              updated_at: premise->Option.map(p => p.updated_at)->Option.getOr(Date.make()),
            }),
          }
          ExecutorUi.Store.makeServerStore(
            config,
            _ => {
              Promise.resolve({
                html: ReactDOMServer.renderToString(
                  <ExecutorUi.App
                    route_root={premise->Option.map(p => p.route_root)->Option.getOr("")}
                    server_url={app_url}
                  />,
                ),
                executorConfig: config,
              })
            },
          )
        },
      )
    )
  )
}
