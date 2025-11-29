let getInventoryList = async () => {
  let query = %sql.many(`
  SELECT * FROM inventory
  `)
  let client = await Connection.getClient()
  let result = await client->query()
  result
}
