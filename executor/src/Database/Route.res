
let getMatchingPremise = async(~client, _root) => {
  let query = %sql.one(`
  SELECT premise_id FROM premise_route
  `)
  let result = await client->query()
  result
}
