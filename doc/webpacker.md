# Webpacker troubleshooting

If you get an `warning Integrity check: Flags don't match` during eg `bundle exec rake app:renalware:webpacker_compile`
this is probably because the webpacker compile rake task forces the production environment, but you have invoked it
while RAILS_ENV=development. In `spec/dummy/config/webpacker.yml` in the development section you probably
have `check_yarn_integrity: true`. If you were to inspect `./node_modules/.yarn-integrity` you might see that
the cause of the error is due to the production flag - ie the node_modules were installed with --production by the rake task
(it hard codes the env) but the integrity check run by webpacker was run as --development. Henc the flags
don't match.

`app:renalware:webpacker_compile` is really for use in the production or staging environment only.
