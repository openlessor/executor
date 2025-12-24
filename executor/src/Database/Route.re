open Common;

[%%mel.raw "const { sql } = require(\"bun\")"];

let getMatchingPremise: string => Js.promise(option(PeriodList.Premise.t)) = [%mel.raw
  {| async function(route_root) {
    let result = await sql`
    SELECT id, name, description, updated_at, route_root FROM premise_route LEFT JOIN premise ON premise.id = premise_route.premise_id WHERE route_root = ${route_root} LIMIT 1
    `;
    return result.pop();
  } |}
];
