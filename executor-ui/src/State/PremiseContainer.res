module GlobalThis = {
  @scope("globalThis") @val
  external window_: Nullable.t<WebAPI.DOMAPI.window> = "window"
}

external env: {..} = "process.env"

module Config = {
  type t = {inventory: array<InventoryItem.t>}

  @scope("JSON") @val
  external parseJSON: string => t = "parse"

  // XXX @todo Make this base URL configurable from an env var
  // window.location.origin is not SSR friendly
  let base_url: string = env["API_BASE_URL"]
  let fetch = async (premiseId: string) => {
    let response = await WebAPI.Global.fetch(
      `${base_url}/config/${premiseId}`,
      ~init={method: "get"},
    )

    let json = await WebAPI.Response.json(response)
    Obj.magic(json)
  }

  module Client = {
    let subscribe = (premise_id: string, set) => {
      let url = WebAPI.URL.make(~url=`${env["API_BASE_URL"]}/events?premise_id=${premise_id}`)
      url.protocol = "ws"

      let ws = WebAPI.WebSocket.make2(~url=url.href)
      ws->WebAPI.WebSocket.addEventListener(Message, event => {
        let jsonR: string = event.data->Option.getUnsafe
        let json = jsonR->JSON.parseOrThrow
        let config: t = {
          inventory: json
          ->JSON.Decode.object
          ->Option.flatMap(d => d->Dict.get("inventory"))
          ->Option.flatMap(JSON.Decode.array)
          ->Option.getOr([])
          ->Array.map(itemJson => {
            // ... decode item ...
            Obj.magic(itemJson) // or proper decoding
          }),
        }
        set(config)
        // set(json)
      })
    }
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
// We need to figure out how to scope this to the correct context in client and server environment.
// For server we need a "session store"
// For client we can use the client side store
let premiseId = "a55351b1-1b78-4b6c-bd13-6859dc9ad410"
let window = switch globalThis["window"]->Nullable.toOption {
| Some(window) => window
| None => {"__EXECUTOR_CONFIG__": Nullable.null}
}
let domExecutorConfig = switch window["__EXECUTOR_CONFIG__"]->Nullable.toOption {
| Some(config) => config
| None => Nullable.null
}
let initialExecutorConfig: Config.t = switch Nullable.toOption(domExecutorConfig) {
| Some(config) => config
| None => SSR.empty // This value is actually not going to be used on the server
}

let state = source(initialExecutorConfig, async (_prev, set) => {
  switch globalThis["window"]->Nullable.toOption {
  | Some(_) => Config.Client.subscribe(premiseId, set)
  | None => () // PremiseContainer.state is only used on the client
  }
})
