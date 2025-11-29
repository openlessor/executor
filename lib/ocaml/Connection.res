open PgTyped

external env: {..} = "process.env"

let getClient = () => {
  let dbConfig = "postgres://executor:executor-password@localhost/executor_db"
  Pg.Client.make(ConnectionString(dbConfig))
}
