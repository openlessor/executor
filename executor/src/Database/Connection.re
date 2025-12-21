[@mel.module "SQL"] external bunSql: string => {..} = "sql";

type json_items = array<{.}>

let sql = ([%mel.raw {| function(query) { bunSql`SELECT * FROM inventory` } |}]: (string) => {..})
