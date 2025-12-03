module Unit = {
  type t = [#second | #minute | #hour | #day | #week | #month | #year]
  // XXX: This default state should come from the server
  let defaultState: t = #month
  let (signal, set) = signal(defaultState)
}

let storage = RescriptBun.AsyncHooks.AsyncLocalStorage.make()

let requestWithStore = (req, callback: RescriptBun.AsyncHooks.AsyncLocalStorage.context<{"test": string}> => 'b) => {
  switch Js.globalThis["window"]->Nullable.toOption {
  | Some(_) => Js.Exn.raiseError("This function should never run in the client context")
  | None => {
      let store: {"test": string} = tilia({
        "test": "Testing Tilia with AsyncLocalStorage on Bun. Request time: "
      })
      RescriptBun.AsyncHooks.AsyncLocalStorage.run(storage, store, callback)
    }
  }
}

// This store needs to be isomorphic so that it's in the context of the user's session on the server
// Otherwise, when we add more Premises I think that it will have the wrong state.
let main_store = carve(({derived}) => {
  {
    "config": PremiseContainer.state,
    "period_list": derived(PeriodList.deriveState),
    "unit": Unit.signal->lift,
  }
})
