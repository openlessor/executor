let getInventoryList = async (~client, premise_id: string) => {
  let result = await client`
  SELECT i.*, JSONB_AGG(TO_JSONB(p.*)) as period_list FROM inventory i
  JOIN inventory_period_map pm ON pm.inventory_id = i.id
  JOIN period p ON p.id = pm.period_id
  WHERE premise_id = ${premise_id}
  GROUP BY i.id, i.premise_id, i.name, i.description, i.quantity
  `
  result->Option.getUnsafe
}

let toInventoryItem = (row): ExecutorUi.InventoryItem.t => {
  let row = row->Nullable.getUnsafe
  let period_list: ExecutorUi.Pricing.period_list = switch row["period_list"] {
  | Some(periods) => Obj.magic(periods)
  | None => []
  }
  {
    description: row["description"],
    id: row["id"],
    name: row["name"],
    quantity: row["quantity"],
    premise_id: row["premise_id"],
    period_list,
  }
}
