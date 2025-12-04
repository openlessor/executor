let getActiveId = (url: RescriptReactRouter.url) => {
  switch url.path {
  | list{"item", id, ..._} => Some(id)
  | _ => None
  }
}

@react.component
let make = (
  //~initialExecutorConfig: option<PremiseContainer.Config.t>=?,
  ~serverUrl: option<RescriptReactRouter.url>=?,
) => {
  let initialUrl = RescriptReactRouter.useUrl(~serverUrl?, ())
  let (url, setUrl) = React.useState(() => initialUrl)
  React.useEffect0(() => {
    let watcherID = RescriptReactRouter.watchUrl(newUrl => {
      setUrl(_ => newUrl)
    })

    // Cleanup function to unsubscribe when the component unmounts
    Some(() => RescriptReactRouter.unwatchUrl(watcherID))
  })

  <>
    {switch url.path {
    | list{"item", ..._} | list{} => <Landing />
    | _ => <NotFound />
    }}
  </>
}
