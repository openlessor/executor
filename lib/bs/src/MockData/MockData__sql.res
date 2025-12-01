/** Types generated for queries found in "src/MockData/MockData.res" */
open PgTyped


/** 'Query1' parameters type */
@gentype
type query1Params = {
  mock_inventory: JSON.t,
  premise_id: string,
}

/** 'Query1' return type */
@gentype
type query1Result = {
  description: string,
  id: int,
  name: string,
  premise_id: string,
  quantity: int,
}

/** 'Query1' query type */
@gentype
type query1Query = {
  params: query1Params,
  result: query1Result,
}

%%private(let query1IR: IR.t = %raw(`{"usedParamSet":{"premise_id":true,"mock_inventory":true},"params":[{"name":"premise_id","required":true,"transform":{"type":"scalar"},"locs":[{"a":77,"b":88}]},{"name":"mock_inventory","required":true,"transform":{"type":"scalar"},"locs":[{"a":202,"b":217}]}],"statement":"INSERT INTO inventory (premise_id, name, description, quantity)\n  SELECT\n    :premise_id!,\n    mock_inventory.name,\n    mock_inventory.description,\n    0\n  FROM json_populate_recordset(null::inventory, :mock_inventory!) as mock_inventory\n  RETURNING *"}`))

/**
 Runnable query:
 ```sql
INSERT INTO inventory (premise_id, name, description, quantity)
  SELECT
    $1,
    mock_inventory.name,
    mock_inventory.description,
    0
  FROM json_populate_recordset(null::inventory, $2) as mock_inventory
  RETURNING *
 ```

 */
@gentype
module Query1: {
  /** Returns an array of all matched results. */
  @gentype
  let many: (PgTyped.Pg.Client.t, query1Params) => promise<array<query1Result>>
  /** Returns exactly 1 result. Returns `None` if more or less than exactly 1 result is returned. */
  @gentype
  let one: (PgTyped.Pg.Client.t, query1Params) => promise<option<query1Result>>
  
  /** Returns exactly 1 result. Raises `Exn.t` (with an optionally provided `errorMessage`) if more or less than exactly 1 result is returned. */
  @gentype
  let expectOne: (
    PgTyped.Pg.Client.t,
    query1Params,
    ~errorMessage: string=?
  ) => promise<query1Result>

  /** Executes the query, but ignores whatever is returned by it. */
  @gentype
  let execute: (PgTyped.Pg.Client.t, query1Params) => promise<unit>
} = {
  @module("pgtyped-rescript-runtime") @new external query1: IR.t => PreparedStatement.t<query1Params, query1Result> = "PreparedQuery";
  let query = query1(query1IR)
  let query = (params, ~client) => query->PreparedStatement.run(params, ~client)

  @gentype
  let many = (client, params) => query(params, ~client)

  @gentype
  let one = async (client, params) => switch await query(params, ~client) {
  | [item] => Some(item)
  | _ => None
  }

  @gentype
  let expectOne = async (client, params, ~errorMessage=?) => switch await query(params, ~client) {
  | [item] => item
  | _ => panic(errorMessage->Option.getOr("More or less than one item was returned"))
  }

  @gentype
  let execute = async (client, params) => {
    let _ = await query(params, ~client)
  }
}

@gentype
@deprecated("Use 'Query1.many' directly instead")
let query1 = (params, ~client) => Query1.many(client, params)


