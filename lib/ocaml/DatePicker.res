%%raw(`import "react-datepicker/dist/react-datepicker.css"`)

module Raw = {
  @react.component @module("../shims/reactDatePickerShim.mjs")
  external make: (
    ~calendarClassName: string,
    ~className: string,
    ~isOpen: bool,
    ~minDate: Date.t,
    ~onChange: Js.Nullable.t<Js.Date.t> => unit,
    ~selected: Date.t,
  ) => React.element = "default"
}

@react.component
let make = (
  ~calendarClassName: string,
  ~className: string,
  ~isOpen: bool,
  ~minDate: Date.t,
  ~onChange: Js.Nullable.t<Js.Date.t> => unit,
  ~selected: Date.t,
) => {
  let (isClient, setIsClient) = React.useState(() => false)
  React.useEffect0(() => {
    setIsClient(_ => true)
    None
  })
  switch isClient {
  | true => <Raw calendarClassName className isOpen minDate onChange selected />
  | false => React.null
  }
}
