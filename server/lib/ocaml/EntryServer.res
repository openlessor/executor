type renderResult = {executorConfig: PremiseContainer.Config.t, html: string}

let render = (url): promise<renderResult> => {
  let appUrl = RescriptReactRouter.dangerouslyGetInitialUrl(~serverUrlString=url, ())
  // XXX: Hardcoded premiseId
  let premiseId = "a55351b1-1b78-4b6c-bd13-6859dc9ad410"
  let toInventoryItem = (row: Inventory__sql.query1Result): InventoryItem.t => {
    let period_list: Pricing.period_list = switch row.period_list {
    | Some(periods) => Obj.magic(periods)
    | None => []
    }
    {
      description: row.description,
      id: row.id,
      name: row.name,
      quantity: row.quantity,
      premise_id: row.premise_id,
      period_list,
    }
  }

  Connection.withClient(client =>
    Premise.getPremise(~client, premiseId)
    ->Promise.then(result => {
      let premise = Nullable.toOption(result)->Belt.Option.getUnsafe
      Inventory.getInventoryList(~client, premiseId)
    })
    ->Promise.then(inventoryRows => {
      let inventory: array<InventoryItem.t> = Belt.Array.map(inventoryRows, toInventoryItem)
      let config: PremiseContainer.Config.t = {inventory: inventory}
      Promise.resolve({
        html: ReactDOMServer.renderToString(
          <App initialExecutorConfig={config} serverUrl={appUrl} />,
        ),
        executorConfig: config,
      })
    })
  )
}
