type t = {
  "premise_id": string,
  "config": ExecutorUi.Config.t,
  "period_list": array<ExecutorUi.Pricing.period>,
  "unit": ExecutorUi.PeriodList.Unit.t,
}

let getStore: unit => t
let makeServerStore: (
  ExecutorUi.Config.t,
  RescriptBun.AsyncHooks.AsyncLocalStorage.context<t> => 'b,
) => 'b
