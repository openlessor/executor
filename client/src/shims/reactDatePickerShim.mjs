import * as ReactDatepickerModule from "react-datepicker";

const ReactDatePicker =
  ReactDatepickerModule?.default?.default ??
  ReactDatepickerModule?.default ??
  ReactDatepickerModule;

export const {
  CalendarContainer,
  getDefaultLocale,
  registerLocale,
  setDefaultLocale,
} = ReactDatepickerModule;

export default ReactDatePicker;
