open State
let str = React.string

let addToCart = (state: Cart.t, id) => {
  {...state, cart: Belt.Array.concat(state.cart, [id])}
}

let removeFromCart = (state: Cart.t, id) => {
  {
    ...state,
    cart: Js.Array.filter(compareId => {
      compareId != id
    }, state.cart),
  }
}

@react.component
let make = leaf(() => {
  let unit = main_store["unit"]
  let now = Js.Date.make()
  let today = Js.Date.fromFloat(
    Js.Date.setHoursMSMs(now, ~hours=0.0, ~minutes=0.0, ~seconds=0.0, ~milliseconds=0.0, ()),
  )

  let (openDate, setOpenDate) = React.useState(() => today)
  let (closeDate, setCloseDate) = React.useState(() => today)
  React.useEffect(() => {
    Js.Console.log("Open Date:")
    Js.Console.log(openDate)
    Js.Console.log("Close Date:")
    Js.Console.log(closeDate)
    Some(() => ())
  }, [openDate, closeDate])

  let updateOpenDate = (openDate: Js.Nullable.t<Js.Date.t>) => {
    setOpenDate(_prev =>
      switch openDate {
      | Js.Nullable.Value(date) => date
      | _ => today
      }
    )
    //setCloseDate(openDate)
  }
  let updateCloseDate = (closeDate: Js.Nullable.t<Js.Date.t>) => {
    setCloseDate(_prev =>
      switch closeDate {
      | Js.Nullable.Value(date) => date
      | _ => today
      }
    )
  }

  let (state, dispatch) = React.useReducer((state, action) => {
    Js.Console.log("calling reducer")
    Js.Console.log({"state": state, "action": action})
    let result = switch action {
    | Cart.DispatchContext.AddToCart({id}) => addToCart(state, id)
    | Cart.DispatchContext.RemoveFromCart({id}) => removeFromCart(state, id)
    }
    Js.Console.log({"nextState": result})
    result
  }, {items: [], selected_item: None, cart: []})
  let cartCount = Belt.Array.length(state.cart)

  <Container>
    <Card className="bg-slate-200/40 border-slate-200/40 border-1">
      <h1 className="text-xl">
        <span>
          <Icon.MonitorCloud
            size={48} className="text-slate-400 mr-2 my-auto inline content-start"
          />
          {"Cloud Hardware Rental"->str}
        </span>
      </h1>
    </Card>
    <Card className="grid grid-cols-[auto_1fr] bg-white/20 gap-4 place-items-start items-center">
      <span className="align-middle text-lg">
        <Icon.Clock className="text-slate-400 mr-2 my-auto inline content-start" size={48} />
        {"Select your reservation type: "->str}
      </span>
      <ReservationTypeSelection />
      <div className="col-span-full grid grid-cols-subgrid relative">
        <Icon.Calendar
          size={48} className="absolute left-0 top-0 bottom-0 my-auto text-slate-400"
        />
        <span className="align-middle text-lg pl-[56px]">
          {"Select your reservation start date: "->str}
        </span>
        <DatePicker
          minDate={today}
          onChange={updateOpenDate}
          isOpen={false}
          className="block outline-slate-400 outline-1 px-2"
          calendarClassName="bg-white"
          selected={openDate}
        />
        <span className={`align-middle text-lg pl-[56px] ${unit == #hour ? "hidden" : ""}`}>
          {"Select your reservation end date: "->str}
        </span>
        <DatePicker
          minDate={openDate}
          selected={closeDate}
          onChange={updateCloseDate}
          isOpen={false}
          className={`block align-end outline-slate-400 outline-1 px-2 ${unit == #hour
              ? "hidden"
              : ""}`}
          calendarClassName="bg-white"
          //selected={}
        />
      </div>
    </Card>
    <Cart.StateContext.Provider value={state}>
      <Cart.DispatchContext.Provider value={dispatch}>
        <InventoryList openDate={openDate} closeDate={closeDate} />
        <Cart count={cartCount} />
      </Cart.DispatchContext.Provider>
    </Cart.StateContext.Provider>
    <div className="w-full">
      <button
        className="mx-auto mt-4 bg-slate-500 hover:bg-slate-700 text-white py-2 px-4 rounded-sm">
        {"Book Reservation"->str}
      </button>
    </div>
  </Container>
})
