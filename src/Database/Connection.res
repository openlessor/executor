open PgTyped

external env: {..} = "process.env"

let getClient = async () => {
  let dbConfig = "postgres://executor:executor-password@localhost/executor_db"
  let client = Pg.Client.make(ConnectionString(dbConfig))
  await client->Pg.Client.connect
  client
}
