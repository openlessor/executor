type headersInit;

type t = headersInit;

external make: {..} => t = "%identity";
external makeWithDict: Js.Dict.t(string) => t = "%identity";
external makeWithArray: array((string, string)) => t = "%identity";
