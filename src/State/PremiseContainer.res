module Config = {
  type t = {inventory: array<InventoryItem.t>}

  @scope("JSON") @val
  external parseJSON: string => t = "parse"

  external env: {..} = "process.env"
  // XXX @todo Make this base URL configurable from an env var
  // window.location.origin is not SSR friendly
  let base_url: string = env["API_BASE_URL"]
  let fetch = async (premiseId: string) => {
    let response = await Webapi.Fetch.fetchWithInit(
      `${base_url}/config/${premiseId}`,
      Webapi.Fetch.RequestInit.make(~method_=Webapi.Fetch.Get, ()),
    )
    parseJSON(await response->Webapi.Fetch.Response.text)
  }
}

module SSR = {
  let empty: Config.t = {inventory: []}
  let context: React.Context.t<Config.t> = React.createContext(empty)

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value: Config.t, ~children: React.element) => {
      let element: React.element = React.createElement(provider, {value, children})
      element
    }
  }
}

// XXX: For now we hardcode the premise ID
let premiseId = "a55351b1-1b78-4b6c-bd13-6859dc9ad410"
let domExecutorConfig: Nullable.t<Config.t> = %raw(
  "(typeof window !== 'undefined' ? window.__EXECUTOR_CONFIG__ ?? null : null)"
)
//let ctx = React.useContext(SSR.context)
let initialExecutorConfig: Config.t = switch Nullable.toOption(domExecutorConfig) {
| Some(config) => config
| None => SSR.empty
}

let state = source(initialExecutorConfig, async (_prev, set) => {
  let config = await Config.fetch(premiseId)
  set(config)
  setInterval(() => {
    Config.fetch(premiseId)->Promise.then(config => Promise.resolve(set(config)))->ignore
  }, 5000)
})
