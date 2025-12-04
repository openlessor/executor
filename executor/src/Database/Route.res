let getMatchingPremise = async (~client, root: string) => {
  Console.log("Looking up root route:" ++ root)
  let query = %sql.one(`
  SELECT id, name, description, updated_at FROM premise_route LEFT JOIN premise ON premise.id = premise_route.premise_id WHERE route_root = :root!
  `)
  let result =
    (await client->query({root: root}))->Option.getOrThrow(~message="Invalid route root:" ++ root)
  result
}
