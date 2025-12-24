open Common;
open Tilia;

type t = {
  // Perhaps the ID should be typed as a UUID?
  premise_id: string,
  config: Config.t,
  period_list: array(Config.Pricing.period),
  unit: PeriodList.Unit.t,
};

let storage =
  switch ([%mel.external window]) {
  | None => Some(AsyncLocalStorage.make())
  | Some(_) => None
  };

let getAsyncLocalStorage = () => {
  // This should never be called on the browser
  storage->Option.get;
};

let derivePremiseId = (store: t) => {
  let premise = store.config.premise->Option.get;
  premise.id;
};

let makeStore = initialExecutorConfig =>
  carve(({derived}) => {
    {
      premise_id: derived(derivePremiseId),
      config: initialExecutorConfig,
      period_list:
        derived((store: t) => {
          let seen_units = Belt.Set.String.empty;
          let config = store.config;
          let inventory = config.inventory->Belt.Array.copy;
          let mapped_inventory =
            inventory->Belt.Array.flatMap(inv => {
              inv.period_list
              |> Array.map((pl: Config.Pricing.period) =>
                   if (seen_units->Belt.Set.String.has(pl.unit)) {
                     None;
                   } else {
                     seen_units->Belt.Set.String.add(pl.unit)->ignore;
                     Some(pl);
                   }
                 )
            });
          Js.Array.filter(
            ~f=
              v =>
                switch (v) {
                | Some(_) => true
                | None => false
                },
            mapped_inventory,
          )
          ->Js.Array.map(~f=v => v->Option.get);
        }),
      unit: PeriodList.Unit.signal->lift,
    }
  });

let makeServerStore = (initialExecutorConfig, callback) => {
  switch ([%mel.external window]) {
  | Some(_) =>
    Js.Exn.raiseError("This function should never run in the client context")
  | None =>
    let als = getAsyncLocalStorage();
    let store = makeStore(initialExecutorConfig);
    als->AsyncLocalStorage.run(store, callback);
  };
};

let getServerStore = () => {
  getAsyncLocalStorage()->AsyncLocalStorage.getStoreExn;
};

// This store needs to be isomorphic so that it's in the context of the user's session on the server
// There may be a better way to do this, but for now I make main_store an option.
// Then I use getStore in my components to get the store based on the execution context.
let main_store: option(t) =
  switch ([%mel.external window]) {
  | Some(_) => Some(makeStore(PremiseContainer.state))
  | None => None
  };

let getStore = () =>
  switch (main_store) {
  | Some(main_store) => main_store
  | None => getServerStore()
  };
