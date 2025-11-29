# executor

To install dependencies:

```bash
bun install
```

**Note**: You may have to use NPM to install dependencies, since it seems to install ReScript v11 instead of ReScript v12. This could be caused by something I'm doing wrong.

To run:

```bash
bun run src/Index.js
```

This project was created using `bun init` in bun v1.3.3. [Bun](https://bun.com) is a fast all-in-one JavaScript runtime.

## Backend Vision

This backend will drive most of the frontend components. The idea is that you set it in the backend, and the frontend just works based on the backend provisioning. 

OpenLessor Executor uses a multi-tenancy model. Each database item is scoped to a tenant ID. You can find the Postgres schemas in the schemas directory of this repository.

The parent database table is the tenant table. All data in the database is a child of the tenant table. Currently, a tenant has inventory assigned to it. Eventually the following child data will be associated with a tenant:
- 

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

## Created by Brian Kaplan @ Software Deployed
[https://softwaredeployed.com](https://softwaredeployed.com)

If you wish to contact me, a contact form is available on the website linked above.
