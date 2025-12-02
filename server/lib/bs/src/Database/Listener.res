open PgListener
external env: {..} = "process.env"

let withListener = (premise_id: string, ~onMessage: message => unit) => {
  let pgp = PgPromise.init()
  let db = pgp(env["DB_URL"])
  let listener = make({pgp, db})

  listener
  ->PgListener.listen(
    [premise_id],
    ~events={
      onMessage: onMessage,
    },
  )
  ->ignore
}
