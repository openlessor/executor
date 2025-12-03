module Unit = {
  type t = [#second | #minute | #hour | #day | #week | #month | #year]
  // XXX: This default state should come from the server
  let defaultState: t = #month
  let (signal, set) = signal(defaultState)
}

let storage = RescriptBun.AsyncHooks.AsyncLocalStorage.make()

let window = globalThis["window"]->Nullable.toOption

let makeServerStore = (
  initialExecutorConfig,
  callback: RescriptBun.AsyncHooks.AsyncLocalStorage.context<'a> => 'b,
) => {
  switch window {
  | Some(_) => JsError.throwWithMessage("This function should never run in the client context")
  | None => {
      Console.log("makeServerStore initialConfig:")
      Console.log(initialExecutorConfig)
      let store = carved(({derived}) => {
        {
          "config": initialExecutorConfig,
          "period_list": ExecutorUi.PeriodList.deriveState(store),
          "unit": Unit.signal->lift,
        }
      })
      storage->RescriptBun.AsyncHooks.AsyncLocalStorage.run(store, callback)
    }
  }
}

let getServerStore = () => {
  storage->RescriptBun.AsyncHooks.AsyncLocalStorage.getStore->Belt.Option.getUnsafe
}

// This store needs to be isomorphic so that it's in the context of the user's session on the server
// Otherwise, when we add more Premises I think that it will have the wrong state.
let main_store = switch window {
| Some(_) =>
  carve(({derived}) => {
    {
      "config": PremiseContainer.state,
      "period_list": derived(PeriodList.deriveState),
      "unit": Unit.signal->lift,
    }
  })
| None => getServerStore()
}
