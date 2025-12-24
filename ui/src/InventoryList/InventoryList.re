open Common;
open Tilia.React;
open Ui;

let str = React.string;

[@react.component]
let make =
  leaf((~openDate: option(Js.Date.t)=?, ~closeDate: option(Js.Date.t)=?) => {
    let main_store = State.Store.getStore();
    let config: Config.t = main_store.config;
    let unit: PeriodList.Unit.t = main_store.unit;
    let items = config.inventory;
    let filterType = "all";
    let today =
      Js.Date.make()
      |> Js.Date.setHoursMSMs(
           ~hours=0.0,
           ~minutes=0.0,
           ~seconds=0.0,
           ~milliseconds=0.0,
         )
      |> Js.Date.fromFloat;
    let openDate =
      switch (openDate) {
      | Some(date) => date
      | _ => today
      };
    let closeDate =
      switch (closeDate) {
      | Some(date) => date
      | _ => today
      };
    let heading =
      if (unit != PeriodList.Unit.Hour && openDate != closeDate) {
        // The open date and close date are at least 1 day apart
        "Showing "
        ++ filterType
        ++ " equipment available from "
        ++ Js.Date.toLocaleDateString(openDate)
        ++ " to "
        ++ Js.Date.toLocaleDateString(closeDate);
      } else {
        "Showing "
        ++ filterType
        ++ " equipment available "
        ++ (
          openDate == today ? "today" : Js.Date.toLocaleDateString(openDate)
        );
      };

    <Card
      className="m-0 p-0 bg-white/30 border-2 border-b-4 border-r-4 border-gray-200/60">
      <h1 className="block align-middle text-lg content-center">
        <Icon.SearchIcon
          size=48
          className="text-slate-400 mr-2 my-auto inline content-start"
        />
        <span className="align-middle"> heading->str </span>
      </h1>
      <Card
        className="border-none shadow-none shadow-transparent m-0 p-0 place-content-start grid lg:grid-cols-8 grid-cols-4 gap-4">
        {Js.Array.map(
           ~f=
             (item: Config.InventoryItem.t) => {
               switch (item.period_list) {
               /*|> Js.Array.find(~f=pl => pl.unit == unit)*/
               | _ => <InventoryItem key={Belt.Int.toString(item.id)} item />
               //| None => React.null
               }
             },
           items,
         )
         ->React.array}
      </Card>
    </Card>;
  });
