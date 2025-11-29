open PgTyped

let getInventoryList = async () => {
  let query = %sql.many(`
  SELECT * FROM inventory
  `)
  let client = Connection.getClient()
  await client->Pg.Client.connect
  let result = await client->query()
  result
}
