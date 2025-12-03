type period = {
  "id": int,
  "unit": string,
  "label": string,
  "price": int,
  "max_value": int,
  "min_value": int,
}
type period_list = array<period>

@react.component
let make = (~period_list: period_list) => {
  let format_price = (p: int) => {
    (Belt.Int.toFloat(p) /. Belt.Int.toFloat(100))->NumberFormatter.formatCurrency->React.string
  }
  let map_period = p => {
    <React.Fragment key={Belt.Int.toString(p["id"])}>
      <div className="border-1 border-black/30 p-1">
        <p className="text-left text-sm"> {p["label"]->React.string} </p>
      </div>
      <div className="border-1 border-black/30 p-1">
        <p className="text-left text-sm"> {format_price(p["price"])} </p>
      </div>
    </React.Fragment>
  }
  <div className="rounded-lg border-1 border-slate-200/50 grid grid-cols-2 bg-white">
    <div className="border-1 border-slate-200/50 bg-black/30 text-white p-1">
      <p className="font-bold text-left"> {"Unit"->React.string} </p>
    </div>
    <div className="border-1 border-slate-200/50 bg-black/30 text-white p-1">
      <p className="font-bold text-left"> {"Price"->React.string} </p>
    </div>
    {period_list->Belt.Array.map(map_period)->React.array}
  </div>
}
