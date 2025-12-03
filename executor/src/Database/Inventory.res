let getInventoryList = async (~client, premise_id: string) => {
  let query = %sql.many(`
  SELECT i.*, JSONB_AGG(TO_JSONB(p.*)) as period_list FROM inventory i
  JOIN inventory_period_map pm ON pm.inventory_id = i.id
  JOIN period p ON p.id = pm.period_id
  WHERE premise_id = :premise_id
  GROUP BY i.id, i.premise_id, i.name, i.description, i.quantity
  `)
  let result = await client->query({premise_id: premise_id})
  result
}

let toInventoryItem = (row: Inventory__sql.query1Result): ExecutorUi.InventoryItem.t => {
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
