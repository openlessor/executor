open PgListener
external env: {..} = "process.env"

let pgp = PgPromise.init()
let db = pgp(env["DB_URL"])
let listener = make({pgp, db})

let withListener = (premise_id: string, ~onMessage: message => unit) => {
  listener
  ->PgListener.listen(
    [premise_id],
    ~events={
      onMessage: onMessage,
    },
  )
  ->ignore
}
