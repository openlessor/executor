let cart_url = "/cart";
let event_url = "/_events";
let item_url = "/item";
let premise_routes = [item_url->String.sub(1)];
let system_routes = [
  cart_url->String.sub(1),
  event_url->String.sub(1),
];
