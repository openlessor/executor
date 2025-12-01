import { defineConfig } from "vite";
import createReactPlugin from "@vitejs/plugin-react";
import createReScriptPlugin from "@jihchi/vite-plugin-rescript";
import tailwindcss from "@tailwindcss/vite";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [createReactPlugin(), createReScriptPlugin(), tailwindcss()],
  server: {
    proxy: {
      // XXX: @todo this should only be for development mode
      "/api": {
        target: "http://localhost:8899", // Your backend API server
        changeOrigin: true, // Changes the Origin header to the target URL
        rewrite: (path) => path.replace(/^\/api/, ""), // Removes '/api' from the request path before forwarding
        secure: false, // Optional: Set to false if your target is not HTTPS
      },
    },
  },
});
