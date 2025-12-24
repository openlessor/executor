open Common;

[%%mel.raw "import { sql } from \"bun\""];

let getInventoryList: string => array(Config.InventoryItem.t) = [%mel.raw
  {| async function(premise_id) { return await sql`
  SELECT i.*, JSONB_AGG(TO_JSONB(p.*)) as period_list FROM inventory i
  JOIN inventory_period_map pm ON pm.inventory_id = i.id
  JOIN period p ON p.id = pm.period_id
  WHERE premise_id = ${premise_id}
  GROUP BY i.id, i.premise_id, i.name, i.description, i.quantity
  ` } |}
];

// XXX: This may not be needed...
let toInventoryItem = (row: Config.InventoryItem.t): Config.InventoryItem.t => {
  {
    description: row.description,
    id: row.id,
    name: row.name,
    quantity: row.quantity,
    premise_id: row.premise_id,
    period_list: row.period_list,
  };
};
