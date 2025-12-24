open Common;

let str = React.string;

type t = {
  cart: array(int),
  selected_item: option(int),
  items: array(Config.InventoryItem.t),
};

let itemCount = state => {
  Array.length(state);
};

module DispatchContext = {
  type action =
    | AddToCart({id: int})
    | RemoveFromCart({id: int});

  let context = React.createContext((_action: action) => ());

  module Provider = {
    let provider = React.Context.provider(context);

    [@react.component]
    let make = (~children, ~value) => {
      let element: React.element =
        React.createElement(
          provider,
          {
            "value": value,
            "children": children,
          },
        );
      element;
    };
  };
};

module StateContext = {
  let state: t = {
    cart: [||],
    selected_item: None,
    items: [||],
  };
  let context = React.createContext(state);

  module Provider = {
    let provider = React.Context.provider(context);

    [@react.component]
    let make = (~children, ~value: t) => {
      let element: React.element =
        React.createElement(
          provider,
          {
            "value": value,
            "children": children,
          },
        );
      element;
    };
  };
};

[@react.component]
let make = (~count) => {
  let _cartState = React.useContext(StateContext.context);
  let _dispatch = React.useContext(DispatchContext.context);
  let main_store = State.Store.getStore();
  let config: Config.t = main_store.config;
  let _items = config.inventory;

  <h1 className="block font-bold align-middle text-gray-700 m-2 text-3xl">
    <span className="m-2 align-middle text-3xl font-light">
      <i className="light-icon-shopping-cart" />
    </span>
    {str("Selected equipment (")}
    {str(Int.to_string(count))}
    {str(")")}
  </h1>;
};
