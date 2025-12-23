module BunRequest = {
  type t = Request.t;
  [@mel.get]
  external params: t => Js.Dict.t(string) = "params";
  //[@mel.get]
  //external cookies: t => CookieMap.t = "cookies";
};

module BunFile = {
  type t;
  [@mel.scope "Bun"]
  external make: string => t = "file";
  [@mel.send]
  external text: t => Js.promise<string>;
  [@mel.send]
  external hostname: t => string;
};
module Response = { type t; };
module Bun = {
  module WebSocket = {
    type webSocketReadyState = | [@mel.as(0)] CONNECTING | [@mel.as(1)] OPEN | [@mel.as(2)] CLOSING | [@mel.as(3)] CLOSED;

    type t('t);

    type config('t) = {.
      message: (t('t), string) => unit,
      [@mel.as("open")] open_: t('t) => unit,
      close: (t('t), int, string) => unit,
      drain: t('t) => unit,
    }
    };
    module Server = {
      type t;
      [@mel.send]
      external upgrade: (t, Request.t) => option(bool) = "upgrade";

    type serveOptions('websocketDataType) = {.
        development: bool,
        port: int,
        fetch: (Request.t, t) => Js.promise(Response.t),
        websocket: WebSocket.config<'websocketDataType>
      };

     external serveWithWebSocket: serveOptions('websocketDataType) => t = "Bun.serve";
  };

  [@mel.unwrap]
  type routeHandlerForMethod =
    Static(Response.t) | Handler((BunRequest.t, Server.t) => Js.promise(Response.t));
  type routeHandlerObject = {get: routeHandlerForMethod};
};

module Route = {
  let getPremiseId = (req) => {
    req->BunRequest.params->Js.Dict.get("premise_id")->Option.get
  };
  module Events = {
    let get = Bun.Handler(
      (req: BunRequest.t, server) => {
        switch (server->Bun.Server.upgrade(req)) {
          | None => Js.Exn.raiseError("Error")
          | Some(_) => Obj.magic(Js.undefined);
        }
      },
    )
    let handler: Bun.routeHandlerObject = {get: get}
  }
  module Frontend = {
    [@mel.val] external doc_root: string = "process.env.DOC_ROOT";
    let html_placeholder = "<!--app-html-->";
    let get = Bun.Handler(
      (req: BunRequest.t, _) => {
        let url = Webapi.Url.make(req->Request.url);
        let headers_dict = Js.Dict.fromArray([|("content-type", "text/html")|]);
        let headers = headers_dict->HeadersInit.makeWithDict;
        let f = BunFile.make(doc_root++"/index.html");
        let template = f->BunFile.text|>Js.Promise.then_(text => Js.Promise.resolve(text));
        let {html, executorConfig} = EntryServer.render(url.pathname);
        let stateJson = executorConfig->JSON.stringifyAny->Option.get;
        let html =
          template
          ->String.replace(html_placeholder, appHtml)
          ->String.replace(
            "</body>",
            "<script>window.__EXECUTOR_CONFIG__="++stateJson++";</script></body>",
          );
        Response.make(html, ~options={headers, status: 200});
      },
    )
    let handler: Bun.routeHandlerObject = {get: get};
  };
  module Config = {
    type output = {
      inventory: array(InventoryItem.t),
      premise: Js.Nullable.t(PeriodList.Premise.t),
    }
    let get = Bun.Handler(
      async (req: BunRequest.t, _) => {
        let headers = Headers.make();
        headers->Headers.set("content-type", "application/json");
        let response: output = await Connection.withClient(async (client) => {
          let premise_id: string = req->getPremiseId;
          let premise = await Premise.getPremise(~client, premise_id);
          let inventory = await Inventory.getInventoryList(~client, premise_id);
          {inventory, premise}
        })
        Response.makeWithJsonUnsafe(response, ~options={headers, status: 200});
      },
    );
    let handler: Bun.routeHandlerObject = {get: get};
  };
  module Inventory = {
    let post = Bun.Handler(
      async (req: BunRequest.t, _) => {
        let premise_id: string = req->getPremiseId;
        await Connection.withClient(async client => {
          await MockData.createMockData(~client, premise_id);
        })l
        Response.make("");
      },
    );
    let handler: Bun.routeHandlerObject = {post: post};
  };
};

module SocketState = {
  if globalThis["published_signal"] == undefined {
    globalThis["published_signal"] = signal(Belt.HashSet.String.make(~hintSize=1024));
  }
  let (published, setPublished) = globalThis["published_signal"];
  let store = tilia({
    "published": computed(() => published->lift),
  });
  let getStore = () => {
    store
  };
};

let subscribeTopic = (ws, premise_id) => {
  Console.log("Subscribing to " ++ premise_id);
  ws->Globals.WebSocket.subscribe(~topic=premise_id);
  let fetchPremiseAndPublish = (premise_id: string, _payload) => {
    Connection.withClient(client => Premise.getConfig(~client, premise_id));
    ->Promise.then(config => {
      Console.log("Got config:");
      Console.log(config);
      ws->Globals.WebSocket.publish(
        ~topic=premise_id,
        ~data=config->JSON.stringifyAny->Option.getUnsafe,
      );
      Promise.resolve(config);
    })
    ->ignore
  }
  let store = SocketState.getStore()
  if store["published"]->Belt.HashSet.String.has(premise_id) == false {
    Listener.withListener(premise_id, ~onMessage=message =>
      fetchPremiseAndPublish(message.channel, message.payload)
    );
  }
  store["published"]->Belt.HashSet.String.add(premise_id);
  SocketState.setPublished(store["published"]);
}

let server = Bun.serveWithWebSocket({
  development: true,
  port: 8899,
  routes: Dict.fromArray([
    ("/", Route.Frontend.handler),
    (Common.Constants.event_url, Route.Events.handler),
    ("/config/:premise_id", Route.Config.handler),
    ("/inventory/:premise_id", Route.Inventory.handler),
  ]),
  websocket: {
    message: (ws, message) => {
      switch message->String.split(" ")->List.fromArray->List.splitAt(1)->Option.getUnsafe {
      | (list{"ping"}, list{}) => ws->Globals.WebSocket.send("pong")
      | (list{"select"}, list{premise_id}) => subscribeTopic(ws, premise_id)
      | _ => ()
      }
    },
    close: (_ws, _, _) => {
      Console.log("Client disconnected")
    },
  },
  fetch: async (req, server) => {
    let url = WebAPI.URL.make(~url=req->Request.url);
    //if (url.pathname == Constants.event_url) {
    //   if (server->Bun.Server.upgrade(req) == false) {
    //     JsError.throwWithMessage("Error");
    //   }
    //   ()
    // }
    let filePath = doc_root++"/"++url.pathname;
    let file = BunFile.make(filePath);
    switch await file->BunFile.exists {
    | true => Response.makeFromFile(file)
    | false =>
      switch Route.Frontend.get {
      | Bun.Handler(handler) => await handler(req, server)
      | _ => Response.make("")
      }
    }
  }
});

let port =
  server
  ->Bun.Server.port
  ->Int.toString;

let hostName = server->Bun.Server.hostname;

Js.log("Server listening on http://"++hostName++":"++port++"!");
