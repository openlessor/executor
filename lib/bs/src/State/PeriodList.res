// I had trouble deriving the state in TiliaJS, so as a woarkaround I just pass the value directly into this function.

let deriveState = store => {
  let seen_units = Set.make()
  let config: PremiseContainer.Config.t = store["config"]
  let inventory = config.inventory->Belt.Array.copy
  inventory
  ->Belt.Array.flatMap(inv => {
    inv.period_list->Js.Array2.map((pl: Pricing.period) => {
      if seen_units->Set.has(pl["unit"]) {
        None
      } else {
        seen_units->Set.add(pl["unit"])->ignore
        Some(pl)
      }
    })
  })
  ->Js.Array2.filter(pl =>
    switch pl {
    | Some(_) => true
    | _ => false
    }
  )
  ->Js.Array2.map(pl => Belt.Option.getUnsafe(pl))
}
