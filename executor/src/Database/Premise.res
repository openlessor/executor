let getPremise = async (~client, premise_id: string) => {
  let result = await client`
  SELECT * FROM premise WHERE id = ${premise_id} LIMIT 1
  `
  switch result {
  | Some(result) => Nullable.Value(result->Array.pop->Option.getOr(null))
  | None => null
  }
}

let getConfig = async (~client, premise_id: string): ExecutorUi.Config.t => {
  let premise = Nullable.toOption(await getPremise(~client, premise_id))->Belt.Option.getUnsafe
  let inventoryRows = await Inventory.getInventoryList(~client, premise_id)
  let inventory: array<ExecutorUi.InventoryItem.t> = Belt.Array.map(
    inventoryRows,
    Inventory.toInventoryItem,
  )

  {
    inventory,
    premise: Some((premise :> ExecutorUi.Premise.t)),
  }
}
