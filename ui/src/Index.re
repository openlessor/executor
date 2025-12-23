// Entry point
// Kind of a crappy workaround to get TailwindCSS working with Bun...
[%%mel.raw "import \"./tailwind.css\""];

let rootElement = ReactDOM.querySelector("#root");

switch (rootElement) {
| Some(domNode) => ReactDOM.Client.hydrateRoot(domNode, <App />)->ignore
| None => Js.log("No root element found")
};
