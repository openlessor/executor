// I had trouble deriving the state in TiliaJS, so as a woarkaround I just pass the value directly into this function.

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
