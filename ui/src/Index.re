// Entry point
// Kind of a crappy workaround to get TailwindCSS working with Bun...
[%mel.raw "import \"./tailwind.css\""];

open ReactDOM.Client;

let rootElement = ReactDOM.querySelector("#root");

switch (rootElement) {
| Some(domNode) => hydrateRoot(domNode, <App />)->ignore
| None => Js.log("No root element found")
};
