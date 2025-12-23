external env: {..} = "process.env";

type t = {
  inventory: array(InventoryItem.t),
  premise: option(PeriodList.Premise.t),
};

module SSR = {
  let empty: t = {
    premise: None,
    inventory: [||],
  };
};
