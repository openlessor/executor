let str = React.string

module IntCmp = Belt.Id.MakeComparable({
  type t = int
  let cmp = Pervasives.compare
})

@react.component
let make = leaf((~openDate: option<Date.t>=?, ~closeDate: option<Date.t>=?) => {
  let main_store = Store.getStore()
  let config: Config.t = main_store["config"]
  let unit: PeriodList.Unit.t = main_store["unit"]
  let items = config.inventory
  let filterType = "all"
  let today = Date.make()
  Date.make()->Date.setHoursMSMs(~hours=0, ~minutes=0, ~seconds=0, ~milliseconds=0)
  let openDate = switch openDate {
  | Some(date) => date
  | _ => today
  }
  let closeDate = switch closeDate {
  | Some(date) => date
  | _ => today
  }
  let heading = {
    if unit != #hour && openDate != closeDate {
      // The open date and close date are at least 1 day apart
      "Showing " ++
      filterType ++
      " equipment available from " ++
      Date.toLocaleDateString(openDate) ++
      " to " ++
      Date.toLocaleDateString(closeDate)
    } else {
      "Showing " ++
      filterType ++
      " equipment available " ++
      switch openDate == today {
      | true => "today"
      | false => Date.toLocaleDateString(openDate)
      }
    }
  }

  <Card className="m-0 p-0 bg-white/30 border-2 border-b-4 border-r-4 border-gray-200/60">
    <h1 className="block align-middle text-lg content-center">
      <Icon.SearchIcon size={48} className="text-slate-400 mr-2 my-auto inline content-start" />
      <span className="align-middle"> {heading->str} </span>
    </h1>
    <Card
      className="border-none shadow-none shadow-transparent m-0 p-0 place-content-start grid lg:grid-cols-8 grid-cols-4 gap-4"
    >
      {Js.Array.map((item: InventoryItem.t) => {
        switch item.period_list->Array.find(pl => pl["unit"] == (unit :> string)) {
        | Some(_) => <InventoryItem key={Belt.Int.toString(item.id)} item={item} />
        | None => React.null
        }
      }, items)->React.array}
    </Card>
  </Card>
})
