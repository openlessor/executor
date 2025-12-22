/*
  Usage:

  let pgp = PgListener.PgPromise.init()
  let db = pgp("postgres://user:password@localhost:5432/database")
  let listener = PgListener.make({pgp, db})

  listener->PgListener.listen(["my_channel"], ~events={
    onMessage: msg => Console.log(msg)
  })->ignore
*/

module PgPromise = {
  [@mel.module] external init: unit => (string => {.}) = "pg-promise";
  type db = {.}
  type main = string => {.}
}

module ReasonPgListener = {
  type t = Js.Dict.t<{.}>
  
  type message = {
    channel: string,
    payload: string,
  }

  type events = {onMessage: message => unit}

  type config = {
    pgp: PgPromise.main,
    db: PgPromise.db,
  }
}
module PgListener = {
  [@mel.module("pg-listener")] external make: ReasonPgListener.config => ReasonPgListener.t = "PgListener"

  [@mel.send] external listen: (ReasonPgListener.t, array<string>, ReasonPgListener.events) => Js.promise<unit> = "listen"
  [@mel.send] external cancelAll: ReasonPgListener.t => Js.promise<unit> = "cancelAll"
}
