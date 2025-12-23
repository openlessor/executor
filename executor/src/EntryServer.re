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
  let premise: PeriodList.Premise.t = Route.getMatchingPremise(route_root);
  let inventory = premise.id |> Inventory.getInventoryList;
  let config: Config.t = {
    inventory,
    premise: Some(premise),
  };
  Store.makeServerStore(config, _ => {
    Js.Promise.resolve({
      html:
        ReactDOMServer.renderToString(<App route_root server_url=app_url />),
      executorConfig: config,
    })
  });
};
