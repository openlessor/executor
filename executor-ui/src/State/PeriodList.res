module Premise = {
  type t = {
    id: string,
    name: string,
    description: string,
    updated_at: Date.t,
  }
}

module Unit = {
  type t = [#second | #minute | #hour | #day | #week | #month | #year]
  // XXX: This default state should come from the server
  let defaultState: t = #month
  let (signal, set) = signal(defaultState)
}

let deriveState = store => {
  let seen_units = Set.make()
  let config: PremiseContainer.Config.t = store["config"]
  let inventory = config.inventory->Belt.Array.copy
  inventory
  ->Belt.Array.flatMap(inv => {
    inv.period_list->Array.map((pl: Pricing.period) => {
      if seen_units->Set.has(pl["unit"]) {
        None
      } else {
        seen_units->Set.add(pl["unit"])->ignore
        Some(pl)
      }
    })
  })
  ->Array.filter(pl =>
    switch pl {
    | Some(_) => true
    | _ => false
    }
  )
  ->Array.map(pl => Belt.Option.getUnsafe(pl))
}
