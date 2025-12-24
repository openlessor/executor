open Common;
open Tilia;

type input_config = {
  inventory: array(Config.InventoryItem.t),
  premise: option(PeriodList.Premise.t),
};

[@mel.scope "window"]
external domExecutorConfig: option(input_config) = "__EXECUTOR_CONFIG__";

Js.log2("Config From DOM:", domExecutorConfig);

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

let state =
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
  );
