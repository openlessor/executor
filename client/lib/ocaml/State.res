@@directive(`"use client"`)

module Unit = {
  type t = [#second | #minute | #hour | #day | #week | #month | #year]
  // XXX: This default state should come from the server
  let defaultState: t = #hour
  let (signal, set) = signal(defaultState)
}
let main_store = carve(({derived}) => {
  {
    "config": PremiseContainer.state,
    "period_list": derived(PeriodList.deriveState),
    "unit": Unit.signal->lift,
  }
})
