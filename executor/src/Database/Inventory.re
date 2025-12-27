open Common;

[%%mel.raw "import { sql } from \"bun\""];

let getInventoryList: string => Js.promise(array(Config.InventoryItem.t)) = [%mel.raw
  {| async function(premise_id) {
console.log("Querying " + premise_id);
  return await sql`
  SELECT i.*, JSONB_AGG(TO_JSONB(p.*)) as period_list FROM inventory i
  JOIN inventory_period_map pm ON pm.inventory_id = i.id
  JOIN period p ON p.id = pm.period_id
  WHERE premise_id = ${premise_id}
  GROUP BY i.id, i.premise_id, i.name, i.description, i.quantity
  ` } |}
];
