type renderResult = {
  executorConfig: Config.t,
  html: string,
};

let render = (url: string): Js.promise(renderResult) => {
  let app_url =
    ReasonReactRouter.dangerouslyGetInitialUrl(~serverUrlString=url, ());
  let requested_root =
    switch (app_url.path->Belt.List.head) {
    | Some(path) => path
    | None => "/"
    };
  let is_child_route =
    Constants.premise_routes->Belt.List.has(requested_root, (a, b) => a == b);
  Js.log(is_child_route);
  let route_root =
    if (is_child_route || app_url.path->Belt.List.length == 0) {
      "/";
    } else {
      "/" ++ app_url.path->Belt.List.head->Option.get;
    };
  Js.log("root route:" ++ route_root);
  let premise =
    Route.getMatchingPremise(route_root)
    |> Js.Promise.then_(premise => premise);
  Inventory.getInventoryList(premise.id))
  |>Js.Promise.then_(inventoryRows => {
      let inventory: array(InventoryItem.t) =
        Belt.Array.map(inventoryRows, Inventory.toInventoryItem);
      let config: ExecutorUi.Config.t = {
        inventory,
        premise:
          Some({
            id: premise->Option.map(p => p.id)->Option.getOr(""),
            name: premise->Option.map(p => p.name)->Option.getOr(""),
            description:
              premise->Option.map(p => p.description)->Option.getOr(""),
            updated_at:
              premise
              ->Option.map(p => p.updated_at)
              ->Option.getOr(Date.make()),
          }),
      };
      ExecutorUi.Store.makeServerStore(config, _ => {
        Promise.resolve({
          html:
            ReactDOMServer.renderToString(
              <ExecutorUi.App
                route_root={
                  premise->Option.map(p => p.route_root)->Option.getOr("")
                }
                server_url=app_url
              />,
            ),
          executorConfig: config,
        })
      });
    });
};
