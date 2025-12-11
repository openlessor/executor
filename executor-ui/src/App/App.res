let getActiveId = (url: RescriptReactRouter.url) => {
  switch url.path {
  | list{"item", id, ..._} => Some(id)
  | _ => None
  }
}

@react.component
let make = (
  //~initialExecutorConfig: option<PremiseContainer.Config.t>=?,
  ~route_root: option<string>=?,
  ~server_url: option<RescriptReactRouter.url>=?,
) => {
  let initial_url = RescriptReactRouter.useUrl(~serverUrl=?server_url, ())
  let (url, set_url) = React.useState(() => initial_url)
  React.useEffect0(() => {
    let watcher_id = RescriptReactRouter.watchUrl(new_url => {
      set_url(_ => new_url)
    })

    // Cleanup function to unsubscribe when the component unmounts
    Some(() => RescriptReactRouter.unwatchUrl(watcher_id))
  })
  let route_root = Option.getWithDefault(route_root, "/")
  let route_root_list = List.fromArray(route_root->String.split("/"))
  let item_route = route_root_list->List.concat(list{"item"})
  Console.log2(route_root, item_route)
  <>
    {switch url.path {
    | list{route_root, ..._} | list{route_root} => <Landing />
    | _ => <NotFound />
    }}
  </>
}
