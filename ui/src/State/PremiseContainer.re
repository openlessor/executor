type premise = {
  id: string,
  name: string,
  description: string,
  updated_at: string,
};
type input_config = {
  inventory: array({. "test": string}),
  premise: option(premise),
};

let domExecutorConfig: option(input_config) =
  switch ([%mel.external window]) {
  | Some(window) =>
    Some(window->Js.Dict.get("__EXECUTOR_CONFIG__")->Option.get)
  | None => None
  };

let empty = {
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

module Tilia = {
  [@mel.module "tilia"] external make: 'a => 'a = "tilia";
  [@mel.module "tilia"]
  external source:
    (. 'a, [@mel.uncurried] ((. 'a, 'a => unit) => 'ignored)) => 'a =
    "source";
};

module Client = {
  let setter =
    (. prev, set) => {
      Js.log(prev);
      set({
        ...empty,
        inventory: [|{"test": "test"}|],
      });
      ();
    };
  let configSource = Tilia.source(. initialExecutorConfig, setter);
  let store = Tilia.make({"config": configSource});
  let subcribe = (_set, _id, _time) => Js.Promise.resolve();
};

/*

 Tilia.source(initialExecutorConfig, (set: input_config) => Js.promise(unit) =>
   Client.subscribe(
     set,
     initialExecutorConfig.id,
     initialExecutorConfig.updated_at->Js.Date.getTime,
   );

    switch (initialExecutorConfig.premise) {
    | Some(premise) =>
      let {updated_at, id, _} = premise;
      switch ([%mel.external window]) {
      | Some(_) => set->Client.subscribe(id, updated_at->Js.Date.getTime)
      | None => () |> Js.Promise.resolve // PremiseContainer.state is only used on the client
      };
    | None => () |> Js.Promise.resolve
    };
  */
