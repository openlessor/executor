open TiliaReact;

let str = React.string;

[@react.component]
let make = () => {
  useTilia();
  let main_store = Store.getStore();

  <div className="my-auto">
    {Array.map(
       (period: Pricing.period) => {
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
               switch (period.unit) {
               | "year" => PeriodList.Unit.set(PeriodList.Unit.Year)
               | "month" => PeriodList.Unit.set(PeriodList.Unit.Month)
               | "week" => PeriodList.Unit.set(PeriodList.Unit.Week)
               | "day" => PeriodList.Unit.set(PeriodList.Unit.Day)
               | "hour" => PeriodList.Unit.set(PeriodList.Unit.Hour)
               | "minute" => PeriodList.Unit.set(PeriodList.Unit.Minute)
               | "second" => PeriodList.Unit.set(PeriodList.Unit.Second)
               | _ => PeriodList.Unit.set(PeriodList.Unit.defaultState)
               }
             }}
             //checked={main_store.unit == period.unit}
             autoComplete="off"
           />
           <span className="p-1 pl-0"> period.label->str </span>
         </label>
       },
       main_store.period_list,
     )
     |> React.array}
  </div>;
};
