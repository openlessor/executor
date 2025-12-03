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
  type db
  type main = string => db
  @module("pg-promise")
  external init: unit => main = "default"
}

type t

type message = {
  channel: string,
  payload: string,
}

type events = {onMessage?: message => unit}

type config = {
  pgp: PgPromise.main,
  db: PgPromise.db,
}

@module("pg-listener") @new
external make: config => t = "PgListener"

@send external listen: (t, array<string>, ~events: events=?) => promise<unit> = "listen"
@send external cancelAll: t => promise<unit> = "cancelAll"
