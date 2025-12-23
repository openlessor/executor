type t('store);
type context('store);

[@mel.send] external disable: t(_) => unit = "disable";

[@mel.module "node:async_hooks"] [@mel.new]
external make: unit => t(_) = "AsyncLocalStorage";
[@mel.send] external run: ('store, context('store) => 'ret) => 'ret = "run";

[@mel.send] external getStore: t('store) => option('store) = "getStore";
[@mel.send] external getStoreUnsafe: t('store) => 'store = "getStore";
[@mel.send] external exit: (t('store), unit => 'ret) => 'ret = "exit";
[@mel.send] external enterWith: (t('store), 't) => unit = "enterWith";
