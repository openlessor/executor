external env: {..} = "process.env"

module Singleton = {
  let make = () => {
    if globalThis["pgOptions"] {
      globalThis["pgListener"]
    } else {
      let pgp = PgListener.PgPromise.init()
      let db = pgp(env["DB_URL"])
      let pgOptions: PgListener.config = {pgp, db}
      globalThis["pgOptions"] = pgOptions
      globalThis["pgListener"] = PgListener.make(pgOptions)
      globalThis["pgListener"]
    }
  }
}

let withListener = (premise_id: string, ~onMessage: PgListener.message => unit) => {
  let pgListener = Singleton.make()
  pgListener
  ->PgListener.listen(
    [premise_id],
    ~events={
      onMessage: onMessage,
    },
  )
  ->ignore
}
