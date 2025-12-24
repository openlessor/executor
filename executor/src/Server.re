[@mel.scope ("process", "env")] external doc_root: string = "DOC_ROOT";
open Database;
open Tilia;
open Fetch;
open Common;

module BunRequest = {
  type t = Request.t;
  [@mel.send] external params: t => Js.Dict.t('a) = "params";
  //[@mel.get]
  //external cookies: t => CookieMap.t = "cookies";
};

module BunFile = {
  type t;
  [@mel.scope "Bun"] external make: string => t = "file";
  [@mel.send] external exists: t => bool = "exists";
  [@mel.send] external text: t => Js.promise(string) = "text";
  [@mel.send] external hostname: t => string = "hostname";
};

module Response = {
  type t;
  type responseInit = {
    status: int,
    headers: Js.Dict.t(string),
  };

  /* NOTE:
     Avoid uncurried `(. ...)` + labeled args on externals; it can trigger
     Melange internal assertion failures in some versions. */
  [@mel.new] external make: (string, ~options: responseInit) => t = "Response";

  [@mel.new] external makeFromFile: BunFile.t => t = "Response";

  external makeWithJsonUnsafe:
    ('jsonCompatiblePayload, ~options: responseInit) => t =
    "Response.json";
};

module Bun_ = {
  type server;

  [@mel.obj]
  external routeHandlerForMethod:
    (
      ~get:
        [@mel.as "GET"] [@mel.unwrap] [
          | `Static(BunRequest.t)
          | `Handler((BunRequest.t, server) => Js.promise(Response.t))
        ]
    ) =>
    Js.promise(Response.t);

  module WebSocket = {
    type webSocketReadyState =
      | [@mel.string 0] CONNECTING
      | [@mel.string 1] OPEN
      | [@mel.string 2] CLOSING
      | [@mel.string 3] CLOSED;

    type t('t);

    type config('t) = {
      message: (t('t), string) => unit,
      //[@mel.string "open"]
      open_: t('t) => unit,
      close: (t('t), int, string) => unit,
      drain: t('t) => unit,
    };
  };

  module Server = {
    type t = server;
    [@mel.send] external upgrade: (t, Request.t) => option(bool) = "upgrade";
    [@mel.get] external hostname: t => string = "hostname";
    [@mel.get] external port: t => int = "port";
    type serveOptions('websocketDataType) = {
      development: bool,
      port: int,
      fetch: (Request.t, t) => Js.promise(Response.t),
      websocket: WebSocket.config('websocketDataType),
      routes: Js.Dict.t(Js.Promise.t(Response.t)),
    };

    [@mel.scope "Bun"]
    external serveWithWebSocket: serveOptions('websocketDataType) => t =
      "serve";
  };
};

module Route = {
  let getPremiseId = req => {
    req->BunRequest.params->Js.Dict.get("premise_id")->Option.get;
  };

  module Events = {
    let handler =
      Bun_.routeHandlerForMethod(
        ~get=
          `Handler(
            (req: BunRequest.t, server) => {
              switch (server->Bun_.Server.upgrade(req)) {
              | None => Js.Exn.raiseError("Error")
              | Some(_) => Obj.magic(Js.undefined)
              }
            },
          ),
      );
  };

  module Frontend = {
    let html_placeholder = "<!--app-html-->";
    let get = (req: BunRequest.t, _) => {
      let url = Webapi.Url.make(req->Request.url);
      let headers = Js.Dict.fromArray([|("content-type", "text/html")|]);
      let f = BunFile.make(doc_root ++ "/index.html");
      f->BunFile.text
      |> Js.Promise.then_(text => {
           let rendered = EntryServer.render(url->Webapi.Url.pathname);
           let appHtml = rendered.html;
           let executorConfig = rendered.executorConfig;
           let stateJson = executorConfig->Js.Json.stringifyAny->Option.get;
           let html =
             text
             |> Js.String.replace(
                  ~search=html_placeholder,
                  ~replacement=appHtml,
                )
             |> Js.String.replace(
                  ~search="</body>",
                  ~replacement=
                    "<script>window.__EXECUTOR_CONFIG__="
                    ++ stateJson
                    ++ ";</script></body>",
                );
           let responseInit: Response.responseInit = {
             status: 200,
             headers,
           };
           Js.Promise.resolve(Response.make(html, ~options=responseInit));
         });
    };
    let handler = Bun_.routeHandlerForMethod(~get=`Handler(get));
  };

  module Config = {
    type output = {
      inventory: array(Config.InventoryItem.t),
      premise: Js.Nullable.t(PeriodList.Premise.t),
    };
    let handler =
      Bun_.routeHandlerForMethod(
        ~get=
          `Handler(
            (req: BunRequest.t, _) => {
              let headers =
                Js.Dict.fromArray([|("content-type", "application/json")|]);
              let premise_id: string = req->getPremiseId;
              let premise = Premise.getPremise(premise_id);
              let inventory = Inventory.getInventoryList(premise_id);
              let response = {
                "inventory": inventory,
                "premise": premise,
              };
              Js.Promise.resolve(
                Response.makeWithJsonUnsafe(
                  response,
                  ~options={
                    headers,
                    status: 200,
                  },
                ),
              );
            },
          ),
      );
  };
  /*module Inventory = {
      let post = Bun_.Handler(
        (req: BunRequest.t, _) => {
          let premise_id: string = req->getPremiseId;
          MockData.createMockData(premise_id);
          Response.make("");
        },
      );
      let handler: Bun_.routeHandlerObject = {post: post};
    };*/
};

module SocketState = {
  let singleton: Js.Dict.t('a) =
    switch ([%mel.external globalThis]) {
    | Some(singleton) => singleton
    | None =>
      Js.Exn.raiseError(
        "globalThis doesn't exist. This should never happen in the Bun runtime.",
      )
    };
  if (singleton->Js.Dict.get("published_signal") == None) {
    singleton->Js.Dict.set(
      "published_signal",
      signal(Belt.HashSet.String.make(~hintSize=1024)),
    );
  };
  let (published, setPublished) =
    singleton->Js.Dict.unsafeGet("published_signal");
  let store = Tilia.make({"published": computed(() => published->lift)});
  let getStore = () => {
    store;
  };
};

/*let subscribeTopic = (ws, premise_id) => {
    //ws->Globals.WebSocket.subscribe(~topic=premise_id);
    let fetchPremiseAndPublish = (premise_id: string, _payload) => {
      let config = Premise.getConfig(premise_id);
      //ws->Globals.WebSocket.publish(
      //  ~topic=premise_id,
      //  ~data=config->Js.Json.stringifyAny->Js.Option.get
      //});
      Js.Promise.resolve(config);
    };
    let store = SocketState.getStore();
    if (store##published->Belt.HashSet.String.has(premise_id) == false) {
      Bus.withListener(premise_id, ~onMessage=message =>
        fetchPremiseAndPublish(message.channel, message.payload) |> ignore
      );
    };
    store##published->Belt.HashSet.String.add(premise_id);
    SocketState.setPublished(store##published);
  };*/

let routes =
  Js.Dict.fromArray([|
    ("/", Route.Frontend.handler),
    (Constants.event_url, Route.Events.handler),
    ("/config/:premise_id", Route.Config.handler),
    //("/inventory/:premise_id", Route.Inventory.handler)
  |]);

let config: Bun_.Server.serveOptions(string) = {
  development: true,
  port: 8899,
  routes,
  websocket: {
    open_: _ws => {
      ();
    },
    drain: _ws => {
      ();
    },
    message: (ws, message) => {
      let tokens = message |> String.split_on_char(' ');
      switch (tokens->Belt.List.splitAt(1)->Option.get) {
      | (["ping"], []) => ws->WebSocket.send_string("pong")
      //      | (["select"], [premise_id]) => subscribeTopic(ws, premise_id)
      | _ => ()
      };
    },
    close: (_ws, _, _) => {
      Js.log("Client disconnected");
    },
  },
  fetch: (req, server) => {
    let url = Webapi.Url.make(req->Request.url);
    //if (url.pathname == Constants.event_url) {
    //   if (server->Bun_.Server.upgrade(req) == false) {
    //     JsError.throwWithMessage("Error");
    //   }
    //   ()
    // }
    let filePath = doc_root ++ "/" ++ url->Webapi.Url.pathname;
    let file = BunFile.make(filePath);
    file->BunFile.exists
      ? Js.Promise.resolve(Response.makeFromFile(file))
      : Route.Frontend.get(req, server);
  },
};
Js.log(routes);
let server = Bun_.Server.serveWithWebSocket(config);
let port = server->Bun_.Server.port->Int.to_string;
let hostName = server->Bun_.Server.hostname;

Js.log("Server listening on http://" ++ hostName ++ ":" ++ port ++ "!");
