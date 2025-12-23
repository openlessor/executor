open Tilia;

type input_config = {
  inventory: array(InventoryItem.t),
  premise: option(PeriodList.Premise.t),
};

let domExecutorConfig: option(input_config) =
  switch ([%mel.external window]) {
  | Some(window) =>
    Some(window->Js.Dict.get("__EXECUTOR_CONFIG__")->Option.get)
  | None => None
  };

let empty: Config.t = {
  inventory: [||],
  premise: None,
};

let initialExecutorConfig =
  switch (domExecutorConfig) {
  | None => empty
  | Some(config) => {
      inventory: config.inventory,
      premise:
        switch (config.premise) {
        | Some(premise) => Some(premise)
        | None => None
        },
    }
  };

source(.
  initialExecutorConfig,
  (. _prev, set) => {
    Client.subscribe(
      set,
      initialExecutorConfig.premise->Option.get.id,
      initialExecutorConfig.premise->Option.get.updated_at->Js.Date.getTime,
    );

    switch (initialExecutorConfig.premise) {
    | Some(premise) =>
      let {id, updated_at, _}: PeriodList.Premise.t = premise;
      switch ([%mel.external window]) {
      | Some(_) => set->Client.subscribe(id, updated_at->Js.Date.getTime)
      | None => () // PremiseContainer.state is only used on the client
      };
    | None => ()
    };
  },
)
|> ignore;
