external env: {..} = "process.env"

type t = {inventory: array<InventoryItem.t>, premise: option<Premise.t>}

// XXX @todo Make this base URL configurable from an env var
// window.location.origin is not SSR friendly
let base_url: string = env["API_BASE_URL"]
let fetch = async (premiseId: string) => {
  let response = await WebAPI.Global.fetch(`${base_url}/config/${premiseId}`, ~init={method: "get"})

  let json = await WebAPI.Response.json(response)
  Obj.magic(json)
}

module SSR = {
  let empty: t = {premise: None, inventory: []}
}
