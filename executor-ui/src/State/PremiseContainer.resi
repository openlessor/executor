module Premise: {
  type t = {
    id: string,
    name: string,
    description: string,
    updated_at: Date.t,
  }
}

module Config: {
  type t = {
    inventory: array<InventoryItem.t>,
    premise: option<Premise.t>,
  }
  let fetch: string => promise<t>
}

module SSR: {
  let empty: Config.t
}
let state: Config.t
