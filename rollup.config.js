// rollupjs setup adapted from the approach used by ActiveStorage

import resolve from "@rollup/plugin-node-resolve"
import commonjs from "@rollup/plugin-commonjs" // required for uglify
import babel from "rollup-plugin-babel"
import { uglify } from "rollup-plugin-uglify" // beautify the js output
import inject from "@rollup/plugin-inject" // allow referencing jquery in stimulus controllers

const uglifyOptions = {
  mangle: false,
  compress: false,
  output: {
    beautify: true,
    indent_level: 2
  }
}

// Had to add context window to avoid rollup converting self to undefined in stimulus
export default {
  context: "window",
  input: "app/javascript/renalware/index.js",
  output: {
    file: "app/assets/javascripts/renalware/rollup_compiled.js",
    format: "esm",
    globals: [ "jquery" ],
    name: "renalwarec-core",
    sourcemap: false,
  },
  plugins: [
    babel(),
    resolve(),
    commonjs(),
    uglify(uglifyOptions),
    inject({
      jQuery: "jquery"
    })
  ]
}
