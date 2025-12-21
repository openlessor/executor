type t = {
  // Perhaps the ID should be typed as a UUID?
  "premise_id": string,
  "config": ExecutorUi.Config.t,
  "period_list": array<ExecutorUi.Pricing.period>,
  "unit": ExecutorUi.PeriodList.Unit.t,
}

let window = globalThis["window"]->Nullable.toOption

let storage = switch window {
| None => Some(RescriptBun.AsyncHooks.AsyncLocalStorage.make())
| Some(_) => None
}

let getAsyncLocalStorage = () => {
  // This should never be called on the browser
  storage->Belt.Option.getUnsafe
}

let derivePremiseId = (store: t) => {
  let premise = store["config"].premise->Option.getOrThrow
  premise.id
}

let makeStore = initialExecutorConfig =>
  carve(({derived}) => {
    {
      "premise_id": derived(derivePremiseId),
      "config": initialExecutorConfig,
      "period_list": derived(ExecutorUi.PeriodList.deriveState),
      "unit": PeriodList.Unit.signal->lift,
    }
  })

let makeServerStore = (
  initialExecutorConfig,
  callback: RescriptBun.AsyncHooks.AsyncLocalStorage.context<'a> => 'b,
) => {
  switch window {
  | Some(_) => JsError.throwWithMessage("This function should never run in the client context")
  | None => {
      let store = makeStore(initialExecutorConfig)
      getAsyncLocalStorage()->RescriptBun.AsyncHooks.AsyncLocalStorage.run(store, callback)
    }
  }
}

let getServerStore = () => {
  getAsyncLocalStorage()->RescriptBun.AsyncHooks.AsyncLocalStorage.getStore->Belt.Option.getUnsafe
}

// This store needs to be isomorphic so that it's in the context of the user's session on the server
// There may be a better way to do this, but for now I make main_store an option.
// Then I use getStore in my components to get the store based on the execution context.
let main_store: option<t> = switch window {
| Some(_) => Some(makeStore(PremiseContainer.state))
| None => None
}

let getStore = () =>
  switch main_store {
  | Some(main_store) => main_store
  | None => getServerStore()
  }
