open Tilia.React;
open Common;

let str = React.string;

[@react.component]
let make = (~item: option(Config.InventoryItem.t)=?) => {
  useTilia();
  let item =
    switch (item) {
    | Some(item) => item
    | None =>
      Js.Exn.raiseError("The item property is required on InventoryItem")
    };
  let image =
    "https://random.danielpetrica.com/api/random?" ++ item.id->Int.to_string;
  //let _dispatch = React.useContext(Cart.DispatchContext.context);
  //let cartState = React.useContext(Cart.StateContext.context);
  //let {path} = RescriptReactRouter.useUrl();
  let matches = [||]; // Js.Array.filter(cart_item => cart_item == item.id, cartState.cart);
  let matchCount = Array.length(matches);
  let _quantity =
    matchCount > 0 ? Int.to_string(Array.length(matches)) : "0";
  let _available = Int.to_string(item.quantity - matchCount);
  // Find matching unit in period_list

  <a
    id={"item-" ++ Int.to_string(item.id)}
    onClick={e => {
      e->React.Event.toSyntheticEvent->React.Event.Synthetic.preventDefault;
      ReasonReactRouter.replace("/item/" ++ Int.to_string(item.id));
    }}
    href={"/item/" ++ Int.to_string(item.id)}
    className="flex flex-1 flex-col grow border-2">
    <button className="relative m-[1.5] flex flex-1 flex-col grow max-w-40">
      <div className="rounded-sm shadow-sm m-0 p-0">
        <img
          className="p-[1.5] w-40 h-40"
          src=image
          style={Obj.magic({"width": "100%"})}
        />
      </div>
      <div
        className="flex flex-row justify-between w-full bg-gray-300 text-white shadow-sm">
        <h2 className="tracking-wider text-xs px-2"> item.name->str </h2>
      </div>
      <div
        className="flex flex-col grow flex-1 w-full bg-white/40 rounded-sm m-[1.5] justify-between items-end">
        <p className="text-xs text-left m-2"> item.description->str </p>
        <Pricing period_list={item.period_list} />
      </div>
    </button>
  </a>;
};
