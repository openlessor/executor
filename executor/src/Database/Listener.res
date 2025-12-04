open PgListener
external env: {..} = "process.env"

let pgp = PgPromise.init()
let db = pgp(env["DB_URL"])
let listener = make({pgp, db})

module Store = {
  let (listenersSignal, setListeners) = signal(List.make(~length=0, ""))
  let store = tilia({
    "listeners": computed(() => listenersSignal->lift),
  })
}
let withListener = (premise_id: string, ~onMessage: message => unit) => {
  let listeners = Store.store["listeners"]->List.toArray->Belt.Set.String.fromArray
  if listeners->Belt.Set.String.has(premise_id) == false {
    Store.setListeners(listeners->Belt.Set.String.add(premise_id)->Belt.Set.String.toList)
    Console.log("Listening on " ++ premise_id)
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
