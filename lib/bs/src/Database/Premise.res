let getPremise = async (~client, premise_id: string) => {
  let query = %sql.one(`
  SELECT * FROM premise WHERE id = :premise_id!
  `)
  let result = await client->query({premise_id: premise_id})
  result->Nullable.fromOption
}
