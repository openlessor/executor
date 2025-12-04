external env: {..} = "process.env"

let storage = RescriptBun.AsyncHooks.AsyncLocalStorage.make()

module Store = {
  let getPgListener = () => {
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
  let (listeners, setListeners) = signal(Belt.HashSet.String.make(~hintSize=1024))
  let store = tilia({
    "listeners": computed(() => listeners->lift),
  })
  /* let pgListener = getPgListener()
  pgListener
  ->PgListener.cancelAll
  ->Promise.then(() => {
    Console.log("Canceled all listeners")
    Promise.resolve()
  })
  ->ignore*/
}

let withListener = (premise_id: string, ~onMessage: PgListener.message => unit) => {
  let pgListener = Store.getPgListener()
  // Running this in AsyncLocalStorage ensures that the listeners hashset and the pgListener remain stable for the entire lifecycle of the server
  storage->RescriptBun.AsyncHooks.AsyncLocalStorage.run(Store.store, _ => {
    let alsStore = storage->RescriptBun.AsyncHooks.AsyncLocalStorage.getStore->Option.getUnsafe
    if alsStore["listeners"]->Belt.HashSet.String.has(premise_id) == false {
      Console.log("Adding listener")
      alsStore["listeners"]->Belt.HashSet.String.add(premise_id)
      Store.setListeners(alsStore["listeners"])
      pgListener
      ->PgListener.listen(
        [premise_id],
        ~events={
          onMessage: onMessage,
        },
      )
      ->ignore
    }
  })
}
