let rootElement = ReactDOM.querySelector("#root");

switch (rootElement) {
| Some(domNode) => ReactDOM.Client.hydrateRoot(domNode, <App />)->ignore
| None => Js.log("No root element found")
};
