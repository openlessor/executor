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

type singleDate = Js.Nullable.t(Js.Date.t);
type multipleDate = array(Js.Date.t);
type rangeDate = {
  from: singleDate,
  [@mel.as "to"]
  to_: singleDate,
};

[@mel.obj]
external makeProps:
  (
    ~mode: 'mode,
    ~onSelect:
      [@mel.unwrap] [
        | `Single(singleDate => unit)
        | `Multiple(multipleDate => unit)
        | `Range(rangeDate => unit)
      ],
    ~selected:
      [@mel.unwrap] [
        | `Single(singleDate)
        | `Multiple(multipleDate)
        | `Range(rangeDate)
      ],
    ~captionLayout: 'captionLayout,
    ~reverseYears: 'reverseYears,
    ~navLayout: 'navLayout,
    ~disableNavigation: 'disableNavigation,
    ~hideNavigation: 'hideNavigation,
    ~animate: 'animate,
    ~fixedWeeks: 'fixedWeeks,
    ~footer: 'footer,
    ~hideWeekdays: 'hideWeedays,
    ~numberOfMonths: 'numberOfMonths,
    ~reverseMonths: 'reverseMonths,
    ~pagatedNavigation: 'pagedNavigation,
    ~showOutsideDays: 'showOutsideDays,
    ~showWeekNumber: 'showWeekNumber,
    ~key: string=?,
    unit
  ) =>
  {
    .
    "mode": 'mode,
    "selected": 'selected,
    "onSelect": 'onSelect,
    "captionLayout": 'captionLayout,
    "reverseYears": 'reverseYears,
    "navLayout": 'navLayout,
    "disableNavigation": 'disableNavigation,
    "hideNavigation": 'hideNavigation,
    "animate": 'animate,
    "fixedWeeks": 'fixedWeeks,
    "footer": 'footer,
    "hideWeekdays": 'hideWeekdays,
    "numberOfMonths": 'numberOfMonths,
    "reverseMonths": 'reverseMonths,
    "pagedNavigation": 'pagedNavigation,
    "showOutsideDays": 'showOutsideDays,
    "showWeekNumber": 'showWeekNumber,
  };

[@mel.module "react-day-picker"]
external make:
  {
    .
    "mode": string,
    "onSelect": rangeDate => unit,
    "selected": rangeDate,
    "captionLayout": captionLayout,
    "navLayout": navLayout,
    "disableNavigation": bool,
    "hideNavigation": bool,
    "animate": bool,
    "fixedWeeks": bool,
    "footer": footer,
    "hideWeekdays": bool,
    "numberOfMonths": int,
    "reverseMonths": bool,
    "pagedNavigation": bool,
    "showOutsideDays": bool,
    "showWeekNumber": bool,
  } =>
  React.element =
  "DayPicker";
