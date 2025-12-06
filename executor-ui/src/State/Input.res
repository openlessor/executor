type t = {
  inventory: array<InventoryItem.t>,
  premise: {
    id: string,
    name: string,
    description: string,
    updated_at: string,
  },
}

@scope("JSON") @val
external parseJSON: string => t = "parse"

let toConfig = data => {
  let input: t = data->parseJSON
  let premise: Premise.t = {
    id: input.premise.id,
    name: input.premise.name,
    description: input.premise.description,
    updated_at: Date.fromString(input.premise.updated_at),
  }
  let inventory: array<InventoryItem.t> = Obj.magic(input.inventory)
  let config: Config.t = {inventory, premise: Some(premise)}
  config
}
