external env: {..} = "process.env"

let dbConfig = env["DB_URL"]
let client = SQL.make(dbConfig)

let getClient = async () => {
  //await client->SQL.connect()
  client
}

let withClient = async fn => {
  let client = await getClient()
  let result = client->fn
  await result->Promise.then(result => {
    client
    ->SQL.end
    ->Promise.then(_ => Promise.resolve(result))
  })
}
