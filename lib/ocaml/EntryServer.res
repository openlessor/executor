type renderResult = {executorConfig: PremiseContainer.Config.t, html: string}

let render = (): promise<renderResult> => {
  let appUrl = RescriptReactRouter.dangerouslyGetInitialUrl(
    ~serverUrlString=`http://localhost:8899/`,
    (),
  )
  // XXX: Hardcoded premiseId
  let premiseId = "a55351b1-1b78-4b6c-bd13-6859dc9ad410"
  PremiseContainer.Config.fetch(premiseId)->Promise.then(config => {
    Console.log("Fetched config: ")
    Console.log(config)
    Console.log("App URL:")
    Console.log(appUrl)
    Promise.resolve({
      html: ReactDOMServer.renderToString(
        <App initialExecutorConfig={config} serverUrl={appUrl} />,
      ),
      executorConfig: config,
    })
  })
}
