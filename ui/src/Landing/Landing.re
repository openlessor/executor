open Tilia.React;
open Ui;

let str = React.string;

let addToCart = (state: Cart.t, id) => {
  {
    ...state,
    cart: Belt.Array.concat(state.cart, [|id|]),
  };
};

let removeFromCart = (state: Cart.t, id) => {
  {
    ...state,
    cart: Js.Array.filter(~f=compareId => {compareId != id}, state.cart),
  };
};

[@react.component]
let make =
  leaf(() => {
    let main_store = State.Store.getStore();
    Js.log(main_store);
    let _unit = main_store.unit;
    let today =
      Js.Date.make()
      |> Js.Date.setHours(
           ~hours=0.0,
           ~minutes=0.0,
           ~seconds=0.0,
           ~milliseconds=0.0,
         )
      |> Js.Date.fromFloat;
    let (openDate, setOpenDate) = React.useState(() => today);
    let (closeDate, setCloseDate) = React.useState(() => today);

    let _updateOpenDate = (openDate: Js.Nullable.t(Js.Date.t)) => {
      setOpenDate(_prev
        =>
          switch (openDate->Js.Nullable.toOption) {
          | Some(date) => date
          | _ => today
          }
        );
        //setCloseDate(openDate)
    };
    let _updateCloseDate = (closeDate: Js.Nullable.t(Js.Date.t)) => {
      setCloseDate(_prev =>
        switch (closeDate->Js.Nullable.toOption) {
        | Some(date) => date
        | _ => today
        }
      );
    };

    let (state, dispatch) =
      React.useReducer(
        (state, action) => {
          let result =
            switch (action) {
            | Cart.DispatchContext.AddToCart({ id }) => addToCart(state, id)
            | Cart.DispatchContext.RemoveFromCart({ id }) =>
              removeFromCart(state, id)
            };
          result;
        },
        {
          items: [||],
          selected_item: None,
          cart: [||],
        },
      );
    let cartCount = Array.length(state.cart);

    <Container>
      <Card className="bg-slate-200/40 border-slate-200/40 border">
        <h1 className="text-xl">
          <span>
            <Icon.MonitorCloud
              size=48
              className="text-slate-400 mr-2 my-auto inline content-start"
            />
            "Cloud Hardware Rental"->str
          </span>
        </h1>
      </Card>
      <Card
        className="grid grid-cols-[auto_1fr] bg-white/20 gap-4 place-items-start items-center">
        <span className="align-middle text-lg">
          <Icon.Clock
            className="text-slate-400 mr-2 my-auto inline content-start"
            size=48
          />
          "Select your reservation type: "->str
        </span>
        <ReservationTypeSelection />
        <div className="col-span-full grid grid-cols-subgrid relative">
          <Icon.Calendar
            size=48
            className="absolute left-0 top-0 bottom-0 my-auto text-slate-400"
          />
          <span className="align-middle text-lg pl-14">
            "Select your reservation start date: "->str
          </span>
          <DayPicker />
          <input
            className="block align-end outline-slate-400 outline-1 px-2"
          />
          <span className="align-middle text-lg pl-14">
            "Select your reservation end date: "->str
          </span>
          <input
            className="block align-end outline-slate-400 outline-1 px-2"
          />
        </div>
      </Card>
      <Cart.StateContext.Provider value=state>
        <Cart.DispatchContext.Provider value=dispatch>
          <InventoryList openDate closeDate />
          <Cart count=cartCount />
        </Cart.DispatchContext.Provider>
      </Cart.StateContext.Provider>
      <div className="w-full">
        <button
          className="mx-auto mt-4 bg-slate-500 hover:bg-slate-700 text-white py-2 px-4 rounded-sm">
          "Book Reservation"->str
        </button>
      </div>
    </Container>;
  });
