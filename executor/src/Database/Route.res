let getMatchingPremise = async (~client, route_root: string) => {
  Console.log("Looking up root route:" ++ route_root)
  let query = %sql.one(`
  SELECT id, name, description, updated_at, route_root FROM premise_route LEFT JOIN premise ON premise.id = premise_route.premise_id WHERE route_root = :route_root!
  `)
  let result =
    (await client->query({route_root: route_root}))->Option.getUnsafe
  result
}
