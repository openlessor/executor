module Config: {
  type t = {inventory: array<InventoryItem.t>}
  let fetch: string => promise<t>
}

module SSR: {
  let empty: Config.t
  let context: React.Context.t<Config.t>
  module Provider: {
    type props<'value, 'children> = {
      value: 'value,
      children: 'children,
    }
    let make: React.componentLike<props<Config.t, React.element>, React.element>
  }
}

let state: Config.t
