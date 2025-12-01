# OpenLessor POC

## Prototype Phase

This software is currently in the prototype phase and is not ready to be used in production. The software design, APIs, and database schemas may completely change by a beta release.

## Preamble

Written using ReScript and React. This is a work in progress. In it's current state, it should not be used by anyone. Any or all of this document is subject to change. 

## Running the frontend POC
Use the Vite-powered SSR dev server so the HTML streamed from the server matches the client-side hydration.

1. Install dependencies: `yarn install`
2. Start the SSR dev server (with hot reload) via `yarn dev`
3. Visit `http://localhost:5173` to interact with the app rendered on the server and hydrated in the browser.

### Production preview
1. Build the client and server bundles: `yarn build`
2. Boot the prebuilt SSR server locally: `yarn preview`
3. Deploy the files inside `dist/client` as static assets and run `yarn start` (or `node server.mjs`) on your server to serve the rendered HTML plus hydration entry.

## Frontend POC URL
Coming soon

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

## Why two separate repositories?
Currently the bindings for ReScript and Bun only support ReScript v12. Most other libraries in the ReScript ecosystem haven't caught up to the breaking changes of ReScript v12 yet. Once this changes, the repositories may be merged so that we can do things like share types between the frontend and backend easily. We will also evaluate if we can run everything using Bun as well, or maybe we should support multiple runtimes?

## Vision

OpenLessor will be an open source project for lease management, and subscription management. It will offer multiple billing types based on time units such as minutes, days, weeks, and months. I am currently working on this in my freetime and my hope is that the project will slowly progress over time. This is the frontend POC which will eventually interact with the backend service. The backend service is also being developed and is available in the [Executor](https://github.com/openlessor/executor) repository.

A key principal of OpenLessor will be performance first. That's why we adapt the latest bleeding edge technology when developing the stack.

# Fully Customizable

The end goal of OpenLessor is to create a completely customizable software that can be easily integrated into your organization.

### Created by Brian Kaplan @ Software Deployed
[https://softwaredeployed.com](https://softwaredeployed.com)

If you wish to contact me, a contact form is available on the website linked above.
