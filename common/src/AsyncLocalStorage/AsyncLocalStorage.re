type t('store);

[@mel.send] external disable: t('store) => unit = "disable";

[@mel.module "node:async_hooks"] [@mel.new]
external make: unit => t('store) = "AsyncLocalStorage";

/* AsyncLocalStorage.run(store, callback) */
[@mel.send]
external run: (t('store), 'store, unit => 'ret) => 'ret = "run";

/* AsyncLocalStorage.getStore(): store | undefined */
[@mel.send]
external getStore: t('store) => option('store) = "getStore";

/* Convenience helper: raise if no store is present */
let getStoreExn = (als: t('store)) => als->getStore->Option.getExn;

/* AsyncLocalStorage.exit(callback) */
[@mel.send]
external exit: (t('store), unit => 'ret) => 'ret = "exit";

/* AsyncLocalStorage.enterWith(store) */
[@mel.send]
external enterWith: (t('store), 'store) => unit = "enterWith";
