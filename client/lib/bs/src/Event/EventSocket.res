@@directive(`"use client"`)

external env: {..} = "process.env"

module Event = {
  type t =
    | Create
    | Update
    | Delete
}

module Client = {
  let subscribe = (premise_id: string, set) => {
    Console.log("Connecting to WebSocket server")
    let url = WebAPI.URL.make(~url=`${env["API_BASE_URL"]}/events?premise_id=${premise_id}`)
    url.protocol = "ws"

    let ws = WebAPI.WebSocket.make2(~url=url.href)
    ws->WebAPI.WebSocket.addEventListenerWithCapture(Message, event => {
      Console.log(event)
    })
    /* Set the onmessage handler
    ws->WebSocket.(
      Null.Value(
        (_ws, event) => {
          Console.log("Received message")
          Console.log(event)
          Obj.magic()
        },
      ),
    )*/
  }
}
