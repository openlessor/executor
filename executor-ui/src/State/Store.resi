type t = {
  "config": ExecutorUi.PremiseContainer.Config.t,
  "period_list": array<ExecutorUi.Pricing.period>,
  "unit": ExecutorUi.PeriodList.Unit.t,
}

let getStore: unit => t
let makeServerStore: (
  ExecutorUi.PremiseContainer.Config.t,
  RescriptBun.AsyncHooks.AsyncLocalStorage.context<t> => 'b,
) => 'b
