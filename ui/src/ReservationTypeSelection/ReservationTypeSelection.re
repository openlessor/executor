let str = React.string

@react.component
let make = leaf(() => {
  let main_store = Store.getStore()
  <div className="my-auto">
    {main_store["period_list"]
    ->Array.map(period => {
      <label className="block" key={period["unit"]} htmlFor={`type_${period["unit"]}`}>
        <input
          className="m-1"
          id={`type_${period["unit"]}`}
          name="type"
          type_="radio"
          value="hour"
          onChange={e => {
            let inputEl = e->ReactEvent.Form.currentTarget
            if inputEl["checked"] == true {
              switch period["unit"] {
              | "year" => PeriodList.Unit.set(#year)
              | "month" => PeriodList.Unit.set(#month)
              | "week" => PeriodList.Unit.set(#week)
              | "day" => PeriodList.Unit.set(#day)
              | "hour" => PeriodList.Unit.set(#hour)
              | "minute" => PeriodList.Unit.set(#minute)
              | "second" => PeriodList.Unit.set(#second)
              | _ => PeriodList.Unit.set(PeriodList.Unit.defaultState)
              }
            }
          }}
          checked={(main_store["unit"] :> string) == period["unit"]}
          autoComplete="off"
        />
        <span className="p-1 pl-0"> {period["label"]->str} </span>
      </label>
    })
    ->React.array}
  </div>
})
