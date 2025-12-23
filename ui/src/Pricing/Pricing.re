type period = {
  id: int,
  unit: string,
  label: string,
  price: int,
  max_value: int,
  min_value: int,
};
type period_list = array(period);

[@react.component]
let make = (~period_list: period_list) => {
  let format_price = (p: int) => {
    (Int.to_float(p) /. Int.to_float(100))
    ->NumberFormatter.formatCurrency
    ->React.string;
  };

  let list_items =
    period_list
    |> Array.map(p => {
         <React.Fragment key={Int.to_string(p.id)}>
           <div className="border-1 border-black/30 p-1">
             <p className="text-left text-sm"> p.label->React.string </p>
           </div>
           <div className="border-1 border-black/30 p-1">
             <p className="text-left text-sm"> {format_price(p.price)} </p>
           </div>
         </React.Fragment>
       });

  <div
    className="w-full rounded-lg border-1 border-slate-200/50 grid grid-cols-2 bg-white">
    <div className="border-1 border-slate-200/50 bg-black/30 text-white p-1">
      <p className="font-bold text-left"> "Unit"->React.string </p>
    </div>
    <div className="border-1 border-slate-200/50 bg-black/30 text-white p-1">
      <p className="font-bold text-left"> "Price"->React.string </p>
    </div>
    {list_items |> React.array}
  </div>;
};
