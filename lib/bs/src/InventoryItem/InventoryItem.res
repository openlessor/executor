let str = React.string

type t = {
  description: string,
  id: int,
  name: string,
  quantity: int,
  premise_id: string,
  period_list: Pricing.period_list,
}

@scope("JSON") @val
external _parseJSON: string => t = "parse"

@react.component
let make = leaf((~item: t) => {
  let {id, name, description, period_list} = item
  let image = "https://random.danielpetrica.com/api/random?" ++ id->Belt.Int.toString
  //let _dispatch = React.useContext(Cart.DispatchContext.context)
  //let cartState = React.useContext(Cart.StateContext.context)
  //let {path} = RescriptReactRouter.useUrl()
  let matches = [] // Js.Array.filter(cart_item => cart_item == item.id, cartState.cart)
  let matchCount = Js.Array.length(matches)
  let _quantity = matchCount > 0 ? Belt.Int.toString(Js.Array.length(matches)) : "0"
  let _available = Belt.Int.toString(item.quantity - matchCount)
  // Find matching unit in period_list

  <a
    id={"item-" ++ Belt.Int.toString(id)}
    onClick={e => {
      e->JsxEvent.toSyntheticEvent->JsxEvent.Synthetic.preventDefault
      RescriptReactRouter.replace("/item/" ++ Belt.Int.toString(id))
    }}
    href={"/item/" ++ Belt.Int.toString(id)}
    className="flex flex-1 flex-col flex-grow border-2">
    <button className="relative m-[1.5] flex flex-1 flex-col flex-grow max-w-40">
      <div className="rounded-sm shadow-sm m-0 p-0">
        <img className="p-[1.5] w-40 h-40" src={image} style={Obj.magic({"width": "100%"})} />
      </div>
      <div className="flex flex-row justify-between w-full bg-gray-300 text-white shadow-sm">
        <h2 className="tracking-wider text-xs px-2"> {name->str} </h2>
      </div>
      <div
        className="flex flex-col flex-grow flex-1 w-full bg-white/40 rounded-sm m-[1.5] justify-between items-end">
        <p className="text-xs text-left m-2"> {description->str} </p>
        <Pricing period_list={period_list} />
      </div>
    </button>
  </a>
})
