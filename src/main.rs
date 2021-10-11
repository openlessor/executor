#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;
extern crate rocket_contrib;

use rocket_sync_db_pools::{diesel, database};

#[database("postgres")]
struct MainDbConn(diesel::PgConnection);

#[launch]
fn rocket() -> _ {
    rocket::build().attach(MainDbConn::fairing())
}
