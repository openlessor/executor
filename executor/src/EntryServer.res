type renderResult = {executorConfig: ExecutorUi.PremiseContainer.Config.t, html: string}

let render = (url: string): promise<renderResult> => {
  let appUrl = RescriptReactRouter.dangerouslyGetInitialUrl(~serverUrlString=url, ())
  // XXX: Hardcoded premiseId
  let premiseId = "a55351b1-1b78-4b6c-bd13-6859dc9ad410"

  Connection.withClient(client =>
    Inventory.getInventoryList(~client, premiseId)->Promise.then(inventoryRows => {
      let inventory: array<ExecutorUi.InventoryItem.t> = Belt.Array.map(
        inventoryRows,
        Inventory.toInventoryItem,
      )
      let config: ExecutorUi.PremiseContainer.Config.t = {
        inventory: inventory
      }
      ExecutorUi.Store.makeServerStore(
        config,
        _ => {
          Promise.resolve({
            html: ReactDOMServer.renderToString(
              <ExecutorUi.App initialExecutorConfig={config} serverUrl={appUrl} />,
            ),
            executorConfig: config,
          })
        },
      )
    })
  )
}
