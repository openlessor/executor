let getPremise = async (~client, premise_id: string) => {
  let query = %sql.one(`
  SELECT * FROM premise WHERE id = :premise_id!
  `)
  let result = await client->query({premise_id: premise_id})
  result->Nullable.fromOption
}

let getConfig = async (
  ~client,
  premise_id: string,
  url: WebAPI.URLAPI.url,
): ExecutorUi.PremiseContainer.Config.t => {
  //let premise = Nullable.toOption(await getPremise(~client, premise_id))->Belt.Option.getUnsafe
  let inventoryRows = await Inventory.getInventoryList(~client, premise_id)
  let inventory: array<ExecutorUi.InventoryItem.t> = Belt.Array.map(
    inventoryRows,
    Inventory.toInventoryItem,
  )
  let url = switch url.pathname {
  | "/" => list{"/"}
  | _ => url.pathname->String.split("/")->List.fromArray
  }
  {inventory, appUrl: url}
}
