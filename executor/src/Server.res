module Route = {
  let getPremiseId = req => {
    req->Bun.BunRequest.params->Dict.get("premise_id")->Option.getUnsafe
  }
  module Frontend = {
    external env: {..} = "process.env"
    let html_placeholder = `<!--app-html-->`
    let get = Bun.Handler(
      async (req: Bun.BunRequest.t, _) => {
        let url = WebAPI.URL.make(~url=req->Request.url)
        let headers = HeadersInit.FromDict(dict{"content-type": "text/html"})
        let f = Bun.file("../public/index.html")
        let template = await f->Bun.BunFile.text
        let {html: appHtml, executorConfig} = await EntryServer.render(url.pathname)
        let stateJson = executorConfig->JSON.stringifyAny->Option.getUnsafe
        let html =
          template
          ->String.replace(html_placeholder, appHtml)
          ->String.replace(
            "</body>",
            `<script>window.__EXECUTOR_CONFIG__=${stateJson};</script></body>`,
          )
        Response.make(html, ~options={headers, status: 200})
      },
    )
    let handler: Bun.routeHandlerObject = {get: get}
  }
  module Config = {
    type output = {
      inventory: array<Inventory__sql.query1Result>,
      premise: Nullable.t<Premise__sql.query1Result>,
    }
    let get = Bun.Handler(
      async (req: Bun.BunRequest.t, _) => {
        let headers = Headers.make()
        headers->Headers.set("content-type", "application/json")
        let response: output = await Connection.withClient(async client => {
          let premise_id: string = req->getPremiseId
          let premise = await Premise.getPremise(~client, premise_id)
          let inventory = await Inventory.getInventoryList(~client, premise_id)
          {inventory, premise}
        })
        Response.makeWithJsonUnsafe(response, ~options={headers, status: 200})
      },
    )
    let handler: Bun.routeHandlerObject = {get: get}
  }
  module Inventory = {
    let post = Bun.Handler(
      async (req: Bun.BunRequest.t, _) => {
        let premise_id: string = req->getPremiseId
        await Connection.withClient(async client => {
          await MockData.createMockData(~client, premise_id)
        })
        Response.make("")
      },
    )
    let handler: Bun.routeHandlerObject = {post: post}
  }
}

external env: {..} = "process.env"
@get external url: WebSocket.t<'a> => Nullable.t<string> = "WebSocket.url"

module SocketState = {
  let storage = RescriptBun.AsyncHooks.AsyncLocalStorage.make()
  let (published, setPublished) = signal(Belt.HashSet.String.make(~hintSize=1024))
  let store = tilia({
    "published": computed(() => published->lift),
  })
  let getStore = () => {
    storage->RescriptBun.AsyncHooks.AsyncLocalStorage.getStore->Option.getUnsafe
  }
}

let server = SocketState.storage->RescriptBun.AsyncHooks.AsyncLocalStorage.run(
  SocketState.store,
  _ =>
    Bun.serveWithWebSocket({
      development: true,
      port: 8899,
      routes: Dict.fromArray([
        ("/", Route.Frontend.handler),
        ("/config/:premise_id", Route.Config.handler),
        ("/inventory/:premise_id", Route.Inventory.handler),
      ]),
      websocket: {
        open_: ws => {
          let websocketUrl: Nullable.t<'a> = ws->url
          let url = switch websocketUrl {
          | Value(unwrapped) => WebAPI.URL.make(~url=unwrapped)
          | _ =>
            WebAPI.URL.make(
              ~url=`${env["API_BASE_URL"]}/events?premise_id=${ExecutorUi.PremiseContainer.premiseId}`,
            )
          }
          Console.log(url)
          let premise_id = switch url.searchParams->WebAPI.URLSearchParams.get("premise_id") {
          | Value(value) => value
          | Null => ExecutorUi.PremiseContainer.premiseId
          }
          Console.log(premise_id)
          ws->Globals.WebSocket.subscribe(~topic=premise_id)
          let fetchPremiseAndPublish = (premise_id: string, payload) => {
            Connection.withClient(client =>
              Promise.resolve(Premise.getConfig(~client, premise_id, url))
            )
            ->Promise.then(config => {
              Console.log("Got config:")
              Console.log(config)
              ws->Globals.WebSocket.publish(
                ~topic=premise_id,
                ~data=config->JSON.stringifyAny->Option.getUnsafe,
              )
              config
            })
            ->ignore
          }
          let store = SocketState.getStore()
          if store["published"]->Belt.HashSet.String.has(premise_id) == false {
            Listener.withListener(premise_id, ~onMessage=message =>
              fetchPremiseAndPublish(message.channel, message.payload)
            )
          }
          store["published"]->Belt.HashSet.String.add(premise_id)
          SocketState.setPublished(store["published"])
        },
        message: (ws, message) => {
          Console.log("Message received:" ++ message)
          if message == "ping" {
            ws->Globals.WebSocket.send("pong")
          }
        },
        close: (_ws, _, _) => {
          Console.log("Client disconnected")
        },
      },
      fetch: async (req, server) => {
        let url = WebAPI.URL.make(~url=req->Request.url)
        if url.pathname == "/events" {
          if server->Bun.Server.upgrade(req) == false {
            JsError.throwWithMessage("Error")
          }
          ()
        }
        let filePath = `../public/${url.pathname}`
        let file = Bun.file(filePath)
        switch await file->Bun.BunFile.exists {
        | true => Response.makeFromFile(file)
        | false =>
          switch Route.Frontend.get {
          | Bun.Handler(handler) =>
            if url.pathname != "/events" {
              await handler(req, server)
            } else {
              Obj.magic(undefined)
            }
          | _ => Response.make("")
          }
        }
      },
    }),
)

// I think this state will be wrong because it can potentially be another user's state?
// So this store should probably be something like a HashMap of the data from the database
// For testing purposes it will suffice
/* observe(() => {
  Console.log("Publishing premiseId: " ++ PremiseContainer.premiseId)
  server->Bun.Server.publish(
    ~topic=PremiseContainer.premiseId,
    ~data=State.main_store["config"].inventory
    ->JSON.stringifyAny
    ->Belt.Option.getUnsafe,
  )
})*/

let port =
  server
  ->Bun.Server.port
  ->Int.toString

let hostName = server->Bun.Server.hostname

Console.log(`Server listening on http://${hostName}:${port}!`)
