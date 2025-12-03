// Entry point
// Kind of a crappy workaround to get TailwindCSS working with Bun...
%%raw(`import "./tailwind.css"`)
%%raw(`import "react-datepicker/dist/react-datepicker.css"`)

open ReactDOM.Client

let rootElement = ReactDOM.querySelector("#root")

switch rootElement {
| Some(domNode) => hydrateRoot(domNode, <App />)->ignore
| None => Console.log("No root element found")
}
