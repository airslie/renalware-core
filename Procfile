# Heroku Procfile - do not use in development
web: bundle exec puma -C ./spec/dummy/config/puma.rb
worker: bundle exec rake app:jobs:work
release: bundle exec rake db:migrate
