# executor

## Preamble

Written using ReScript and React. This is a work in progress. In it's current state, it should not be used by anyone. Any or all of this document is subject to change. 

## Who is Executor for? 

Some example use cases:
- Hardware Cloud Equipment Rental
- Apartment / Room Rental
- Cloud Server
- Website Subscription

## Important Note

This project is currently using forked dependencies `tilia` and `@tilia/react` to work with ReScript v12. I've submitted a PR with the TiliaJS project.

## Prototype Phase

This software is currently in the prototype phase and is not ready to be used in production. The software design, APIs, and database schemas may completely change by a beta release.

## Running with Bun runtime

To install dependencies:

```bash
bun install
```

## pgtyped-rescript

Run the development tool in watch mode:

```bash
npx pgtyped-rescript -w -c pgtyped.config.json
```

## Development server

1. Install dependencies using pnpm: `pnpm install`
2. Start the ReScript watch and Bun dev server: `pnpm dev`
3. Visit `http://localhost:8899` to interact with the app rendered on the server and hydrated in the browser.

## Backend Vision

This backend will drive most of the frontend components. The idea is that you set it in the backend, and the frontend just works based on the backend provisioning. 

OpenLessor Executor uses a multi-tenancy model. Each database item is scoped to a tenant ID. You can find the Postgres schemas in the schemas directory of this repository.

The parent database table is the tenant table. All data in the database is a child of the tenant table. Currently, a tenant has inventory assigned to it.

Inventory will have child data as well. This child data will dictate: Time model, Billing model, and Provisioning model. Here's an example, we will mostly use a familiar concept of renting housing:
- Create a tenant called "Fair Lane Apartments"
- The tenant has inventory of every unit available
- Each inventory has customized metadata attached to it. For example, unit number, number of rooms, square footage, etc.
- Each inventory has conditions attached to it. This is mostly to due with availability of inventory. More on this later.
- Each inventory has a Time model; for example an apartment can be rented by the Month.
- Each inventory has a Billing model; for example an apartment can be paid for by electronic ACH. This also would allow applicable fees, deposits, etc. to be applied throughout the rental process. For example, you can set an application fee to be applied that is non-refundable when someone applies to the apartment. And you can require something like first month rent and a deposit is required to move in.
- Each inventory has a Provisioning model. For example, a tangible good like an apartment would be provisioned using a signed lease. While a digital good like a cloud server would be provisioned by executing a software routine like a HTTP POST or SSH workflow.
- You can assign a "lease holder" to each inventory.

This can be applied to anything billed on a recurring model. More to come on vision as the software progresses. Most of the business logic of OpenLessor will live in Executor.

## Vision

OpenLessor will be an open source project for omnichannel commerce, lease management, and subscription management. It will offer multiple billing types based on time units such as minutes, days, weeks, and months. I am currently working on this in my freetime and my hope is that the project will slowly progress over time. This is the fullstack monorepository for OpenLessor. It currently runs using the Bun JavaScript runtime. Tech stack:

- PostgreSQL - pgtyped-rescript
- Bun JavaScript runtime
- ReScript / rescript-bun

A key principal of OpenLessor will be performance first. That's why we adapt the latest bleeding edge technology when developing the stack.

# Fully Customizable Vision

Not only should performance be blazing fast, but also integration...

The end goal of OpenLessor is to create a completely customizable software that can be easily integrated into your organization.

## Created by Brian Kaplan @ Software Deployed
[https://softwaredeployed.com](https://softwaredeployed.com)

If you wish to contact me, a contact form is available on the website linked above.
