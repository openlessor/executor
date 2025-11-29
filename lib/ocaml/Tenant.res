let getTenant = async (~client, tenantId: string) => {
  let query = %sql.one(`
  SELECT * FROM tenant WHERE id = :tenantId!
  `)
  let result = await client->query({tenantId: tenantId})
  result->Nullable.fromOption
}
