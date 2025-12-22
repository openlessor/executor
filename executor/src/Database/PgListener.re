/*
  Usage:

  let pgp = PgListener.PgPromise.init()
  let db = pgp("postgres://user:password@localhost:5432/database")
  let listener = PgListener.make({pgp, db})

  listener->PgListener.listen(["my_channel"], ~events={
    onMessage: msg => Console.log(msg)
  })->ignore
*/
module ReasonPgPromise = {
  type t
}
module PgPromise = {
  type t
  type db
  type func = [@u](string => db);
  type pgp = [@u]unit => func;

  [@mel.module] external make: pgp = "pg-promise";
}

module ReasonPgListener = {
  type t
  
  type message = {
    channel: string,
    payload: string,
  }

  type events = {onMessage: message => unit}

  type config = {
    pgp: PgPromise.func,
    db: PgPromise.db,
  }
}

[@mel.module("pg-listener")] [@mel.new] external make: ReasonPgListener.config => ReasonPgListener.t = "PgListener"
[@mel.send] external listen: (ReasonPgListener.t, array<string>, ReasonPgListener.events) => Js.promise<unit> = "listen"
[@mel.send] external cancelAll: ReasonPgListener.t => Js.promise<unit> = "cancelAll"
