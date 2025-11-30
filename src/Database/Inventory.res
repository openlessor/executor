let getInventoryList = async (~client, premise_id: string) => {
  let query = %sql.many(`
  SELECT * FROM inventory WHERE premise_id = :premise_id
  `)
  let result = await client->query({premise_id: premise_id})
  result
}
