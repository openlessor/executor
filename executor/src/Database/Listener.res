open PgListener
external env: {..} = "process.env"

let pgp = PgPromise.init()
let db = pgp(env["DB_URL"])
let listener = make({pgp, db})

module Store = {
  //let (listenersSignal, setListeners) = signal(Set.make())
  let store = tilia({
    "listeners": Set.make(),
  })
}
let withListener = (premise_id: string, ~onMessage: message => unit) => {
  let listeners = Store.store["listeners"]
  Console.log(listeners)
  if listeners->Set.has(premise_id) == false {
    Console.log("Listening on " ++ premise_id)
    listener
    ->PgListener.listen(
      [premise_id],
      ~events={
        onMessage: onMessage,
      },
    )
    ->ignore
  } else {
    listeners->Set.add(premise_id)
  }
}
