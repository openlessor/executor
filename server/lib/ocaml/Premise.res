let getPremise = async (~client, premise_id: string) => {
  let query = %sql.one(`
  SELECT * FROM premise WHERE id = :premise_id!
  `)
  let result = await client->query({premise_id: premise_id})
  result->Nullable.fromOption
}

/**

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
XXX: This needs to be fully in sync with the client store implementation as well.
**/
let getConfig = async (~client, premise_id: string): PremiseContainer.Config.t => {
  //let premise = Nullable.toOption(await getPremise(~client, premise_id))->Belt.Option.getUnsafe
  let inventoryRows = await Inventory.getInventoryList(~client, premise_id)
  let inventory: array<InventoryItem.t> = Belt.Array.map(inventoryRows, Inventory.toInventoryItem)

  {inventory: inventory}
}
