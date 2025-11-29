let getInventoryList = async (~client, tenantId: string) => {
  let query = %sql.many(`
  SELECT * FROM inventory WHERE tenantId = :tenantId
  `)
  let result = await client->query({tenantId: tenantId})
  result
}
