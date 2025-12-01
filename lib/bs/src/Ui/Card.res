open Cx

@react.component
let make = (~children, ~className: option<string>=?) => {
  Js.Console.log("classes:" ++ className->Option.getOr(""))
  <div className={["m-1 p-1 bg-slate-100/70 border-hairline border-b-2 border-slate-200 shadow-sm shadow-slate-200/70 rounded-lg", className->Option.getOr("")]->cx}>
    {children}
  </div>
}
