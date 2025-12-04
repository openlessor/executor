let getMatchingPremise = async (~client, root: string) => {
  Console.log("Looking up root route:" ++ root)
  let query = %sql.one(`
  SELECT premise_id FROM premise_route WHERE route_root = :root!
  `)
  let result =
    (await client->query({root: root}))->Option.getOrThrow(~message="Invalid route root:" ++ root)
  result.premise_id->Option.getUnsafe
}
