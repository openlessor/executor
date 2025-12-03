/** Types generated for queries found in "src/Database/Inventory.res" */
open PgTyped


/** 'Query1' parameters type */
@gentype
type query1Params = {
  premise_id?: string,
}

/** 'Query1' return type */
@gentype
type query1Result = {
  description: string,
  id: int,
  name: string,
  period_list: option<Connection.json_items>,
  premise_id: string,
  quantity: int,
}

/** 'Query1' query type */
@gentype
type query1Query = {
  params: query1Params,
  result: query1Result,
}

%%private(let query1IR: IR.t = %raw(`{"usedParamSet":{"premise_id":true},"params":[{"name":"premise_id","required":false,"transform":{"type":"scalar"},"locs":[{"a":186,"b":196}]}],"statement":"SELECT i.*, JSONB_AGG(TO_JSONB(p.*)) as period_list FROM inventory i\n  JOIN inventory_period_map pm ON pm.inventory_id = i.id\n  JOIN period p ON p.id = pm.period_id\n  WHERE premise_id = :premise_id\n  GROUP BY i.id, i.premise_id, i.name, i.description, i.quantity"}`))

/**
 Runnable query:
 ```sql
SELECT i.*, JSONB_AGG(TO_JSONB(p.*)) as period_list FROM inventory i
  JOIN inventory_period_map pm ON pm.inventory_id = i.id
  JOIN period p ON p.id = pm.period_id
  WHERE premise_id = $1
  GROUP BY i.id, i.premise_id, i.name, i.description, i.quantity
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


