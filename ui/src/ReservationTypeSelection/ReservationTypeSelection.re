open Common;
open Tilia.React;

let str = React.string;

[@react.component]
let make =
  leaf(() => {
    let main_store = State.Store.getStore();
    <div className="my-auto">
      {main_store.period_list
       |> Array.map((period: Config.Pricing.period) =>
            <label
              className="block"
              key={period.unit}
              htmlFor={"type_" ++ period.unit}>
              <input
                className="m-1"
                id={"type_" ++ period.unit}
                name="type"
                type_="radio"
                value="hour"
                onChange={_e => {
                  //let inputEl = e->React.Event.Form.currentTarget;
                  //if (inputEl["checked"] == true) {
                  PeriodList.Unit.set(
                    PeriodList.Unit.tFromJs(period.unit)->Option.get,
                  )
                }}
                checked={
                  main_store.unit
                  == PeriodList.Unit.tFromJs(period.unit)->Option.get
                }
                autoComplete="off"
              />
              <span className="p-1 pl-0"> period.label->str </span>
            </label>
          )
       |> React.array}
    </div>;
  });
