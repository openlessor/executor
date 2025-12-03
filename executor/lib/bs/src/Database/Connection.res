open PgTyped

type json_items = array<{.}>

external env: {..} = "process.env"

let dbConfig = env["DB_URL"]
//let pool = Pg.Pool.make(ConnectionString(dbConfig))

let getClient = async () => {
  let client = Pg.Client.make(ConnectionString(dbConfig))
  //let client = await pool->Pg.Pool.connect
  await client->Pg.Client.connect
  client
}

let withClient = async fn => {
  let client = await getClient()
  let result = client->fn
  await result->Promise.then(result => {
    client
    ->Pg.Client.end
    ->Promise.then(_ => Promise.resolve(result))
  })
}
