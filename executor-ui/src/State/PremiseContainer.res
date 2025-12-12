let window = switch globalThis["window"]->Nullable.toOption {
| Some(window) => window
| None => {"__EXECUTOR_CONFIG__": Nullable.null}
}

module InputConfig = {
  type t = {
    inventory: array<InventoryItem.t>,
    premise: nullable<
      {
        id: string,
        name: string,
        description: string,
        updated_at: string,
      },
    >,
  }
}

let domExecutorConfig: nullable<InputConfig.t> = window["__EXECUTOR_CONFIG__"]
let initialExecutorConfig: Config.t = switch domExecutorConfig {
| Nullable.Undefined | Nullable.Null => Config.SSR.empty
| Nullable.Value(config) => {
    inventory: config.inventory,
    premise: switch config.premise {
    | Nullable.Value(premise) =>
      Some({
        id: premise.id,
        name: premise.name,
        description: premise.description,
        updated_at: premise.updated_at->Date.fromString,
      })
    | Nullable.Undefined | Nullable.Null => Config.SSR.empty.premise
    },
  }
}

let state = source(initialExecutorConfig, async (_prev, set) => {
  switch initialExecutorConfig.premise {
  | Some(premise) => {
      let {updated_at, id} = premise
      switch globalThis["window"]->Nullable.toOption {
      | Some(_) => set->Client.subscribe(id, updated_at->Date.getTime)
      | None => () // PremiseContainer.state is only used on the client
      }
    }
  | None => ()
  }
})
