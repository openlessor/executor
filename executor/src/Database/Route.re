open Common;

[%%mel.raw "const { sql } = require(\"bun\")"];

let getMatchingPremise = (route_root: string): Js.Promise.t(PeriodList.Premise.t) => {
  [%mel.raw
    {| async function(route_root) {
    return await sql`
    SELECT id, name, description, updated_at, route_root FROM premise_route LEFT JOIN premise ON premise.id = premise_route.premise_id WHERE route_root = ${route_root}
    `
    } |}
  ](route_root);
};
