# Webpacker troubleshooting

If you get an `warning Integrity check: Flags don't match` during eg `bundle exec rake app:renalware:webpacker_compile`
this is probably because the webpacker compile rake task forces the production environment, but you have invoked it
while RAILS_ENV=development. In `spec/dummy/config/webpacker.yml` in the development section you probably
have `check_yarn_integrity: true`. If you were to inspect `./node_modules/.yarn-integrity` you might see that
the cause of the error is due to the production flag - ie the node_modules were installed with --production by the rake task
(it hard codes the env) but the integrity check run by webpacker was run as --development. Henc the flags
don't match.

`app:renalware:webpacker_compile` is really for use in the production or staging environment only.

## Update 19 Nov 2019

Webpacker removed from the engine as I think its the wrong solution. Ideally we need to build and
publish an npm package + package.json that the host app can reference in its package.json.
This way dependencies like lodash etc are included once. It also simplifies the engine - adding
webpacker added lots of uncessary complexity.
However in the meantime we will use the asset pipeline.
Introducing Sprockets 4 has allowed us to use es6 and stimulus, albeit in a less sophisiticated
way.
