Basically the goal right now is to support the following for the initial release. Having said that, I’m typically overambitious and this will be shortlisted to essential features to push out a release:
- Any unit of time, time-based billing. From the second to the year.
 - Rules in place for these periods, right now it’s simple and it’s only min amount / max amount.
- Inventory is associated with these periods. Inventory can be: Services, Tangible Goods, etc.
- I’ve created a concept called a “Premise” which is essentially the parent object or scope of Inventory. This can be used to do things like split responsibility (think different staff roles), use the same backend for multiple businesses, etc. The idea is that you can use some JavaScript and just pass in the Premise ID (which is a random UUIDv4) and it will pull and render everything from the backend.
- ReactJS components to render inventory, pricing, timer / elapsed time, etc, although I want to make it so you can actually use any components that use JSX. Which is actually a possibility with ReScript. Also for example the state management library I’m using is not coupled to React.
  - End goal is to have a fully customizable UI experience (the only requirement is JSX)
- Simple admin backend 

Future:
- Fully customizable Administrator panel with granular roles, access control, etc.
-  Pluggable UI allowing you to use any JSX-based UI components.
- Fully customizable and overridable declarative UI / styling system.

Currently implemented:
- Realtime WebSocket, ping/pong connection failure detection, auto-reconnect, subscribe to state updates over WebSocket using the active Premise ID.
- PostgreSQL database triggers for sending notifications when a Premise or it’s children are updated.
- Map a root URL to a Premise (for example “/“ or “/movies”) — eventually more mappings will be available. The idea will be that you can configure based on domain name, URL, etc. You can embed or do a customized implementation for full performance, etc.

Partially implemented:
- In the catchall Bun handler, add a way to load the root URL for a Premise so you don’t have to configure each one. Make it so the child links work top down from the root URL. (i.e.: make the Postgres table the driver for this.)
   - Fail to start if a URL name is used that is reserved for system use.
   - Change the system use URLs like the socket to have a underscore in front of it (events -> _events) — In case you want to name your root events.
- Updating inventory from empty to non-empty for a premise

TODO (Web channel is focus for now, then mobile and b&m):
- Rewrite Postgres stored function in JavaScript compiled from ReScript and create a declarative framework for easily updating this logic
- Add “Out of stock” or similar (customizable) message when no inventory available. 
- Come up with a way to configure stock in different ways. For example, “Intangible items (infinite quantity)”, “Tangible items (finite quantity)”, etc.
- Create “Purchase Flows” — The ability to customize the entire flow of a purchase. From simple to advanced.
   - Hook system or Pluggable extension system using NPM packages and the “hook” system (not to be confused with React hook)
   - Configuration based customization, like POST to this URL and if JSON key “paid” equals “true” do this.
- Administrator backend
   - GUI for “Configuration based customization"
- Create fully customizable UI driver so you stay on brand.

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
