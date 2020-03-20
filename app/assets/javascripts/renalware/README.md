# Javascript

The js or js.erb files in this top-level folder will be compiled and linked
by sprockets 4 as individually downloadble .js assets.

core.js.erb is the main js file which imports other .js files in
./components and includes js assets from external gem dependencies.

See https://github.com/rails/sprockets#link_directory


## rollupjs

We use rollupjs to compile js and css assets.

### rollup_compiled.js

This is the js output from ruinning `rollup --config rollup.config.js`
and is the compiled output from app/javascripts/renalware/index.js.

You need to have run `yarn install` before running rollup.

To keep rollup running (watching for changes), add the ` -w` switch to the rollup
command.

### rollup_compiled.css

This is the css the tailwindcss npm package, compiled and purged
(unused classes removed) by postcss -> purgecss. In development however this
file will be the whole of tailwind (1.6Mb) but when deployed in a stgaing or
production environment withh purged to a few hundred kb.
The file is checked-in to git. The first time you run up the project you need
to run `yarn install` and `rollup --config rollup.config.js` to generate this file.
