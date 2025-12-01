Basically the goal right now is to support the following for the initial release. Having said that, I’m typically overambitious and this will be shortlisted to essential features to push out a release:
- Any unit of time, time-based billing. From the second to the year.
 - Rules in place for these periods, right now it’s simple and it’s only min amount / max amount.
- Inventory is associated with these periods. Inventory can be: Services, Tangible Goods, etc.
- I’ve created a concept called a “Premise” which is essentially the parent object or scope of Inventory. This can be used to do things like split responsibility (think different staff roles), use the same backend for multiple businesses, etc. The idea is that you can use some JavaScript and just pass in the Premise ID (which is a random UUIDv4) and it will pull and render everything from the backend.
- ReactJS components to render inventory, pricing, timer / elapsed time, etc, although I want to make it so you can actually use any components that use JSX. Which is actually a possibility with ReScript. Also for example the state management library I’m using is not coupled to React.
  - End goal is to have a fully customizable UI experience (the only requirement is JSX)
- Full server rendering for performance. This is already done using Vite bundler.
- WebSockets to enable real-time events, etc.
- Simple admin backend 

Future:
- Merge the frontend and backend into one repository using ReScript v12, Bun runtime. Currently it’s in two different packages since ReScript just upgraded to v12, so some packages that haven’t caught up yet are only working on v11.
- Fully customizable Administrator panel with granular roles, access control, etc.
-  Pluggable UI allowing you to use any JSX-based UI components.
- Fully customizable and overridable declarative UI / styling system.
