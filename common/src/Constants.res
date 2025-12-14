let cart_url = "/cart"
let event_url = "/_events"
let item_url = "/item"
let premise_routes = list{item_url->String.substring(1)}
let system_routes = list{cart_url->String.substring(1), event_url->String.substring(1)}
