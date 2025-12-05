# OpenLessor POC

## Prototype Phase

This software is currently in the prototype phase and is not ready to be used in production. The software design, APIs, and database schemas may completely change by a beta release.

## Preamble

Written using ReScript and React. This is a work in progress. In it's current state, it should not be used by anyone. Any or all of this document is subject to change. 

## Running the frontend POC
Use the Bun powered server for development with --hot flag:
`bun --hot executor/src/Server.mjs`

1. Install dependencies using pnpm: `pnpm install`
2. Start the SSR dev server (with hot reload) via `pnpm dev`
3. Visit `http://localhost:8899` to interact with the app rendered on the server and hydrated in the browser.

## Use Cases for OpenLessor POC (frontend components will eventually be packaged as reusable React component library)
- Hardware Cloud Equipment Rental
- Apartment / Room Rental
- Cloud Server
- Website Subscription

## Plans for Frontend POC (written in ReScript using ReScript React)
- Nearly zero configuration React components which you simply need to point to Executor endpoint URL to bootstrap
- Styled using Tailwind CSS and packaged via Vite's SSR + client hydration pipeline
- Frontend POC will run Vite Server, possibly deployed to CloudFlare containers

## Plans for Backend POC (OpenLessor Executor; written in ReScript using rescript-bun)
- Multiple billing period type (i.e.: seconds, minutes, days, weeks, months)
- Configurable to call a provisioner (i.e.: hook for GET/POST URL during different phases; open source micro service for this TBD)
- Each product subscription type will have it's own unique endpoint URL for configuring frontend React HOC
- Service POC will be deployed to serverless infrastructure (service used TBD, maybe Vercel)

All with multiple billing types depending on if it fits the use case; such as per minute, per day, per week, per month.

## Vision

OpenLessor will be an open source project for omnichannel commerce, lease management, and subscription management. It will offer multiple billing types based on time units such as minutes, days, weeks, and months. I am currently working on this in my freetime and my hope is that the project will slowly progress over time. This is the fullstack monorepository for OpenLessor. It currently runs using the Bun JavaScript runtime. Tech stack:

- PostgreSQL - pgtyped-rescript
- Bun JavaScript runtime
- ReScript / rescript-bun

A key principal of OpenLessor will be performance first. That's why we adapt the latest bleeding edge technology when developing the stack.

# Fully Customizable

Not only should performance be blazing fast, but also integration...

The end goal of OpenLessor is to create a completely customizable software that can be easily integrated into your organization.

### Created by Brian Kaplan @ Software Deployed
[https://softwaredeployed.com](https://softwaredeployed.com)

If you wish to contact me, a contact form is available on the website linked above.
