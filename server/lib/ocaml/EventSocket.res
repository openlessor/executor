@@directive(`"use client"`)

external env: {..} = "process.env"

module Event = {
  type t =
    | Create
    | Update
    | Delete
}

module Client = {
  let subscribe = (premise_id: string) => {
    let url = WebAPI.URL.make(~url=`${env["API_BASE_URL"]}/events?premise_id=${premise_id}`)
    url.protocol = "ws"

    let ws = WebSocket.make(url.href)
    // Set the onmessage handler
    ws->WebSocket.onmessage(
      Null.Value(
        (_ws, event) => {
          Console.log("Received message")
          Console.log(event)
          Obj.magic()
        },
      ),
    )
  }
}
