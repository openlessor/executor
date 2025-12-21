let getActiveId = (url: RescriptReactRouter.url) => {
  switch url.path {
  | list{"item", id, ..._} => Some(id)
  | _ => None
  }
}

let getRootlessPath = (route_root, path) => {
  if Common.Constants.premise_routes->List.has(route_root, (a, b) => a === b) {
    Some(path)
  } else {
    let route_root_prefix = route_root->String.split("/")
    //->Array.filter(value => value->String.length > 0)
    let root_idx = route_root_prefix->Array.length - 1
    Console.log(root_idx)
    let? Some((_, rootless_path)) = path->List.splitAt(root_idx->Math.Int.min(0))
    Some(rootless_path) //->Option.getOr(List.make(~length=0, ""))
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
  let rootless_path = switch route_root {
  | Some(route_root) => getRootlessPath(route_root, url.path)
  | None => Some(list{})
  }
  Console.log(rootless_path)
  switch rootless_path {
  | Some(list{"item", ..._}) | Some(list{}) => <Landing />
  | _ => <NotFound />
  }
}
