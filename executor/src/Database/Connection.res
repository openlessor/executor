open PgTyped

type json_items = array<{.}>

external env: {..} = "process.env"

let dbConfig = env["DB_URL"]
let pool = Pg.Pool.make(Obj.magic({"max": 100, "connectionString": dbConfig}))

let getClient = async () => {
  let client = await pool->Pg.Pool.connect
  client
}

let withClient = async fn => {
  let client = await getClient()
  let result = client->fn
  await result->Promise.then(result => {
    // The Pg.Client.release returns undefined, not promise<unit>
    // That's why it can't be sent directly to Promise.then
    Promise.resolve(client->Pg.Client.release)->Promise.then(_ => Promise.resolve(result))
  })
}
