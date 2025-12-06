external env: {..} = "process.env"

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
  let select = (premise_id: string) => {
    ws->WebAPI.WebSocket.send4(`select ${premise_id}`)
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
  ws->WebAPI.WebSocket.addEventListener(Custom("open"), _event => {
    select(premise_id)
  })
  ws->WebAPI.WebSocket.addEventListener(Close, _event => {
    Console.log("WebSocket closed, reconnecting")
    subscribe(premise_id, state["updated_at"], set)
  })
  ws->WebAPI.WebSocket.addEventListener(Message, event => {
    let data: string = event.data->Option.getUnsafe
    if data == "pong" {
      set_last_pong_ts(Date.fromString("now")->Date.getTime)
    } else {
      let config = data->Input.toConfig

      switch config.premise {
      | Some(premise) => set_updated_ts(premise.updated_at->Date.getTime)
      | _ => set_updated_ts(Date.now())
      }
      set(config)
    }
  })
}
