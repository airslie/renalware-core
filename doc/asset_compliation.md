# Javascript asset compilation

While a standard Rails 6+ app might use webpacker to pull in javascript dependencies (via yarn)
and deliver them with its own js content as javascript packs,
life in an Rails engine is a little different, and
at the time of writing (Feb 2020) support for webpack and the webacker gem in engines is
[rather sketchy](https://github.com/rails/webpacker/blob/master/docs/engines.md).
There are a couple of somewhat hacky ways to use it and we have tried both; one has a fatal
limitation in our use case and the other feels wrong.

When it comes to delivering assets from an engine you have to ask how you want the host to
ingest them - via webpacker, meaning you'll probably need to publish the engine's asset to npm or
GH packages etc - or via the asset pipline. The latter is much easier and that is the approach we
are taking in renalware-core, at least until webpacker engine support improves.
While we could publish a js package for the host to reference in their package.json, it will
start to introduce new processes and checks (ie that they have the same version of both gem and
npm package!). For the moment we are resisting this.

Our basic approach is:

- es6 javascript files livee in app/javascripts, including stimulus controllers
- app/javascripts/index.js is the main file that rollupjs will process
- if making changes to js files in this folder you'll need to run rollup using
`rollup --config rollup.config.js -w` (the -w is for watch) or `yarn run build`.
This will bundle the files, run them through babel so the output is IE11-compliant, run them through
uglifier to beautify them, and drop the output file into `app/assets/javascripts/`.
From here the bundled file will get pulled into the main renalware/core.js when assets
are precompiled at deployment. So unlike asset precompilation, the generation of the rolluped
js file in app/assets/javascripts happens at development time.
There is a check on CI which runs `yarn run build` and a `git status` to make sure the file is up to
date - if it isnt one needs to run rollup locally to update it, commit it and push.

Longer term we'll come up with a slicker solution.
