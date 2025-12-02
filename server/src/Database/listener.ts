import pgPromise from "pg-promise";
import { PgListener, IListenEvents } from "pg-listener";

const pgp = pgPromise();

const db = pgp({
  user: "user-name",
  database: "db-name",
  // etc.
  keepAlive: true,
});

const ls = new PgListener({ pgp, db });

const events: IListenEvents = {
  onMessage(msg) {
    console.log(msg); //=> {channel,length,payload,processId}
  },
  // See also: onConnected, onDisconnected, onFailedReconnect
};

// listen to 2 channels on one connection:
ls.listen(["channel_1", "channel_2"], events)
  .then((result) => {
    // Successful Initial Connection;
    // result = {createIterable, cancel, notify, etc.}
  })
  .catch((err) => {
    // Failed Initial Connection
  });
