type captionLayout =
  | Label
  | Dropdown
  | DropdownMonths
  | DropdownYears;

let captionLayoutToString = (v: captionLayout): string =>
  switch (v) {
  | Label => "label"
  | Dropdown => "dropdown"
  | DropdownMonths => "dropdown-months"
  | DropdownYears => "dropdown-years"
  };

type navLayout =
  | Around
  | After;

let navLayoutToString = (v: navLayout): string =>
  switch (v) {
  | Around => "around"
  | After => "after"
  };

/* `footer` can be a string or a React node. */
type footer =
  | FooterString(string)
  | FooterNode(React.element);

[@mel.module "react-day-picker"] [@react.component]
external make:
  (
    ~mode: string=?,
    ~selected: Js.Date.t=?,
    ~onSelect: 'a => unit=?,
    ~captionLayout: captionLayout=?,
    ~reverseYears: bool=?,
    ~navLayout: navLayout=?,
    ~disableNavigation: bool=?,
    ~hideNavigation: bool=?,
    ~animate: bool=?,
    ~fixedWeeks: bool=?,
    ~footer: footer=?,
    ~hideWeekdays: bool=?,
    ~numberOfMonths: int=?,
    ~reverseMonths: bool=?,
    ~pagedNavigation: bool=?,
    ~showOutsideDays: bool=?,
    ~showWeekNumber: bool=?
  ) =>
  React.element =
  "DayPicker";
