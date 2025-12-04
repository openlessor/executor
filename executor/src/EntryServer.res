type renderResult = {executorConfig: ExecutorUi.PremiseContainer.Config.t, html: string}

let render = (url: string): promise<renderResult> => {
  let appUrl = RescriptReactRouter.dangerouslyGetInitialUrl(~serverUrlString=url, ())
  let root_route = if appUrl.path->Belt.List.length == 0 {
    "/"
  } else {
    appUrl.path->Belt.List.head->Option.getUnsafe
  }
  Console.log("root route:" ++ root_route)

  Connection.withClient(client =>
    Route.getMatchingPremise(~client, root_route)->Promise.then(premise =>
      Inventory.getInventoryList(~client, premise.id)->Promise.then(
        inventoryRows => {
          let inventory: array<ExecutorUi.InventoryItem.t> = Belt.Array.map(
            inventoryRows,
            Inventory.toInventoryItem,
          )
          let config: ExecutorUi.PremiseContainer.Config.t = {
            inventory,
            appUrl: appUrl.path,
            premise: Some({
              id: premise.id,
              name: premise.name,
              description: premise.description,
              updated_at: premise.updated_at,
            }),
          }
          ExecutorUi.Store.makeServerStore(
            config,
            _ => {
              Promise.resolve({
                html: ReactDOMServer.renderToString(<ExecutorUi.App serverUrl={appUrl} />),
                executorConfig: config,
              })
            },
          )
        },
      )
    )
  )
}
