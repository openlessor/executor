open Common;
open Tilia;

type input_premise = Js.Dict.t(string);

type input_config = {
  inventory: array(Config.InventoryItem.t),
  premise: option(input_premise),
};

let domExecutorConfig =
  switch ([%mel.external window]) {
  | Some(window) => window->Js.Dict.get("__EXECUTOR_CONFIG__")
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
        | Some(premise_in) =>
          Some({
            id: premise_in->Js.Dict.unsafeGet("id"),
            name: premise_in->Js.Dict.unsafeGet("name"),
            description: premise_in->Js.Dict.unsafeGet("description"),
            updated_at:
              premise_in->Js.Dict.unsafeGet("updated_at")
              |> Js.Date.fromString,
          })
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
