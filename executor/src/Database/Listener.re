external env: Js.Dict.t<string> = "process.env"

module Singleton = {
  let connect = () => {
    let db_url = env->Js.Dict.get("DB_URL")->Option.get
    let pgp = PgListener.PgPromise.init()
    let db = pgp(db_url)
    let pgOptions: PgListener.ReasonPgListener.config = {pgp, db}
    let pgListener = PgListener.PgListener.make(pgOptions)
    pgListener
  }
  let connection = connect()
}

let withListener = (premise_id: string, ~onMessage: PgListener.ReasonPgListener.message => unit) => {
  let pgListener = Singleton.connection
  pgListener
  ->PgListener.PgListener.listen(
    [|premise_id|],
    {
      onMessage: onMessage,
    },
  )
  ->ignore
}
