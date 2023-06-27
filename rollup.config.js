// rollupjs setup adapted from the approach used by ActiveStorage
var devEnv = (process.env.NODE_ENV || "development") == "development";

import resolve from "@rollup/plugin-node-resolve"
import commonjs from "@rollup/plugin-commonjs" // required for uglify
import babel from "rollup-plugin-babel"
import pkg from "./package.json"
import livereload from "rollup-plugin-livereload"

const watchDirectories = [
  pkg.main,
  "app/views",
  "app/components",
  "spec/dummy/app/assets/builds", // Output from Tailwindcss and JS
]

// Had to add context window to avoid rollup converting self to undefined in stimulus
export default {
  context: "window",
  input: "app/javascript/renalware/application.js",
  output: {
    file: pkg.main,
    format: "esm",
    //format: "es",
    inlineDynamicImports: true,
    globals: {
      jquery: "jQuery",
    },
    name: "renalware-core",
    sourcemap: true,
  },
  plugins: [
    babel(),
    resolve(),
    commonjs(),
    process.env.ROLLUP_WATCH && devEnv &&
      livereload({
        watch: watchDirectories,
        // If true, set `config.assets.digest = false` in development.rb
        applyCSSLive: false,
        extraExts: ["slim"],
        debug: false,
      }),
  ],
  external: [],
}
