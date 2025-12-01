// Entry point
%%raw(`import "./tailwind.css"`)
%%raw(`import "react-datepicker/dist/react-datepicker.css"`)

open ReactDOM.Client

let rootElement = ReactDOM.querySelector("#root")

switch rootElement {
| Some(domNode) => hydrateRoot(domNode, <App />)->ignore
| None => Js.log("No root element found")
}
