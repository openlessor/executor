let getPremise = (premise_id: string) => {
  let query = %sql.one(`
  SELECT * FROM premise WHERE id = :premise_id!
  `)
  let result = await client->query({premise_id: premise_id})
  result->Js.Nullable.return
}

let getConfig = (premise_id: string): Js.promise(array({.})) => {
  let premise = Js.Nullable.toOption(getPremise(premise_id))->Option.get
  let inventoryRows = await Inventory.getInventoryList(~client, premise_id)
  let inventory: array<ExecutorUi.InventoryItem.t> = Belt.Array.map(
    inventoryRows,
    Inventory.toInventoryItem,
  )

  {
    inventory,
    premise: Some(premise),
  }
}

type t = {
  id: string,
  name: string,
  description: string,
  updated_at: Date.t,
}
