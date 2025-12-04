external env: {..} = "process.env"

let window = switch globalThis["window"]->Nullable.toOption {
| Some(window) => window
| None => {"__EXECUTOR_CONFIG__": Nullable.null}
}

/* @TODO XXX Add this to a shared module so it can be shared between both repositories */
module Premise = {
  type t = {
    id: string,
    name: string,
    description: string,
    updated_at: Date.t,
  }
}

module InputConfig = {
  type t = {
    inventory: array<InventoryItem.t>,
    appUrl: list<string>,
    premise: nullable<
      {
        id: string,
        name: string,
        description: string,
        updated_at: string,
      },
    >,
  }
}

module Config = {
  type t = {inventory: array<InventoryItem.t>, appUrl: list<string>, premise: option<Premise.t>}

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
    let rec subscribe = (premise_id: string, updated_at: float, set) => {
      Console.log("Premise_id:" ++ premise_id)
      Console.log("updated_at: ")
      Console.log(updated_at)
      let url = WebAPI.URL.make(
        ~url=`${env["API_BASE_URL"]}/events?premise_id=${premise_id}&ts=${updated_at->Float.toString}`,
      )
      url.protocol = "ws"

      let ws = WebAPI.WebSocket.make2(~url=url.href)
      let pathname = WebAPI.Global.location.pathname
      let path = switch pathname {
      | "/" => list{"/"}
      | _ => pathname->String.split("/")->List.fromArray
      }
      Console.log(path)
      let timeout = 5.0
      let (last_pong_ts, set_last_pong_ts) = signal(0.0)
      let (last_ping_ts, set_last_ping_ts) = signal(0.0)
      let (updated_ts, set_updated_ts) = signal(updated_at)
      let state = tilia({
        "last_ping": last_ping_ts->lift,
        "last_pong": last_pong_ts->lift,
        "updated_at": updated_ts->lift,
      })
      let send_ping = () => {
        if ws.readyState == 1 {
          // I don't know if this is the best way to send a ping packet or not.
          ws->WebAPI.WebSocket.send4("ping")
          set_last_ping_ts(Date.fromString("now")->Date.getTime)
        }
      }
      observe(() => {
        let elapsed = state["last_pong"] - state["last_ping"]
        if elapsed > timeout {
          Console.log("No pong received from server, reconnecting...")
          ws->WebAPI.WebSocket.close
          subscribe(premise_id, Date.now(), set)
        }
      })
      if globalThis["interval"] == undefined {
        globalThis["interval"] = setInterval(() => send_ping(), Float.toInt(timeout) * 1000)->ignore
      }
      ws->WebAPI.WebSocket.addEventListener(Close, _event => {
        Console.log("WebSocket closed, reconnecting")
        setTimeout(() => subscribe(premise_id, state["updated_at"], set), 1000)->ignore
      })
      ws->WebAPI.WebSocket.addEventListener(Message, event => {
        let data: string = event.data->Option.getUnsafe
        Console.log("Got data:" ++ data)
        if data == "pong" {
          set_last_pong_ts(Date.fromString("now")->Date.getTime)
        } else {
          let config = data->parseJSON
          switch config.premise {
          | Some(premise) => set_updated_ts(premise.updated_at->Date.getTime)
          | _ => set_updated_ts(Date.now())
          }
          set(config)
        }
      })
    }
  }
}

module SSR = {
  let empty: Config.t = {premise: None, inventory: [], appUrl: list{}}
}

let domExecutorConfig: nullable<InputConfig.t> = window["__EXECUTOR_CONFIG__"]
let initialExecutorConfig: Config.t = switch domExecutorConfig {
| Nullable.Undefined | Nullable.Null => SSR.empty
| Nullable.Value(config) => {
    inventory: config.inventory,
    appUrl: config.appUrl,
    premise: switch config.premise {
    | Nullable.Value(premise) =>
      Some({
        id: premise.id,
        name: premise.name,
        description: premise.description,
        updated_at: premise.updated_at->Date.fromString,
      })
    | Nullable.Undefined | Nullable.Null => SSR.empty.premise
    },
  }
}

let state = source(initialExecutorConfig, async (_prev, set) => {
  switch initialExecutorConfig.premise {
  | Some(premise) => {
      let {updated_at, id} = premise
      Console.log("PREMISE:")
      Console.log(premise)
      switch globalThis["window"]->Nullable.toOption {
      | Some(_) => Config.Client.subscribe(id, updated_at->Date.getTime, set)
      | None => () // PremiseContainer.state is only used on the client
      }
    }
  | None => ()
  }
})
