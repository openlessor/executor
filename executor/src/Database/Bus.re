external env: Js.Dict.t<string> = "process.env"

module Singleton = {
  let pgp = ()
}


let connect = () => {
  let db_url = env->Js.Dict.get("DB_URL")->Option.get
  Js.log(db_url)
  let pgp = PgListener.PgPromise.make(.())
  let db = pgp(.db_url)
  Js.log([%mel.raw "pgp.name"])
  Js.log(db)
  let pgOptions: PgListener.ReasonPgListener.config = {pgp, db}
  let pgListener = PgListener.make(pgOptions)
  pgListener
}

let withListener = (premise_id: string, ~onMessage: PgListener.ReasonPgListener.message => unit) => {
  let pgListener = connect()
  pgListener
  ->PgListener.listen(
    [|premise_id|],
    {
      onMessage: onMessage,
    },
  )
  ->ignore
}
