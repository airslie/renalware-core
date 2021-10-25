// rollupjs setup adapted from the approach used by ActiveStorage

import resolve from "@rollup/plugin-node-resolve"
import commonjs from "@rollup/plugin-commonjs" // required for uglify
import babel from "rollup-plugin-babel"
import inject from "@rollup/plugin-inject" // allow referencing jquery in stimulus controllers

// Had to add context window to avoid rollup converting self to undefined in stimulus
export default {
  context: "window",
  input: "app/javascript/renalware/index.js",
  output: {
    file: "app/assets/javascripts/renalware/built.js",
    format: "esm",
    //format: "es",
    inlineDynamicImports: true,
    globals: {
      "jquery": "jQuery",
      "chartkick": "Chartkick",
      "highcharts": "Highcharts"
    },
    name: "renalware-core",
    sourcemap: false,
  },
  plugins: [
    babel(),
    resolve(),
    commonjs(),
    inject({
      jQuery: "jquery"
    })
  ],
  external: [ "chartkick", "highcharts" ]
}
