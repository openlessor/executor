open State
let str = React.string

@react.component
let make = leaf(() => {
  <div className="my-auto">
    {main_store["period_list"]
    ->Js.Array2.map(period => {
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
              | "year" => State.Unit.set(#year)
              | "month" => State.Unit.set(#month)
              | "week" => State.Unit.set(#week)
              | "day" => State.Unit.set(#day)
              | "hour" => State.Unit.set(#hour)
              | "minute" => State.Unit.set(#minute)
              | "second" => State.Unit.set(#second)
              | _ => State.Unit.set(State.Unit.defaultState)
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
