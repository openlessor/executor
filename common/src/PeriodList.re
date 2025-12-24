open Tilia;

module Premise = {
  type t = {
    id: string,
    name: string,
    description: string,
    updated_at: Js.Date.t,
  };
};

module Unit = {
  type t =
    | [@mel.string "second"] Second
    | [@mel.string "minute"] Minute
    | [@mel.string "hour"] Hour
    | [@mel.string "day"] Day
    | [@mel.string "week"] Week
    | [@mel.string "month"] Month
    | [@mel.string "year"] Year;
  // XXX: This default state should come from the server
  let defaultState: t = Month;
  let (signal, set) = signal(defaultState);
};
