open PgListener
external env: {..} = "process.env"

let pgp = PgPromise.init()
let db = pgp(env["DB_URL"])
let listener = make({pgp, db})

module Store = {
  let (listenersSignal, setListeners) = signal(Belt.HashSet.String.make(~hintSize=0))
  let store = tilia({
    "listeners": computed(() => listenersSignal->lift),
  })
}
let withListener = (premise_id: string, ~onMessage: message => unit) => {
  let listeners = Store.store["listeners"]
  if listeners->Belt.HashSet.String.has(premise_id) == false {
    listeners->Belt.HashSet.String.add(premise_id)
    Store.setListeners(listeners)
    listener
    ->PgListener.listen(
      [premise_id],
      ~events={
        onMessage: onMessage,
      },
    )
    ->ignore
  }
}
