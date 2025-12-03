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
      let store = carve(({derived}) => {
        {
          "config": initialExecutorConfig,
          "period_list": derived(ExecutorUi.PeriodList.deriveState),
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
// There may be a better way to do this, but for now I make main_store an option.
// Then I use getStore in my components to get the store based on the execution context.
let main_store = switch window {
| Some(_) =>
  Some(
    carve(({derived}) => {
      {
        "config": PremiseContainer.state,
        "period_list": derived(PeriodList.deriveState),
        "unit": Unit.signal->lift,
      }
    }),
  )
| None => None
}

let getStore = () =>
  switch main_store {
  | Some(main_store) => main_store
  | None => getServerStore()
  }
