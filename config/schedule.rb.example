# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# On the first of each month at 3am kick off a task to generate and store (audit)
# monthly patient statistics. This will run in the "production" environment only.
# Note this job will be (re-)created by capistrano on deployment - see config/deploy.rb and
# https://github.com/javan/whenever#capistrano-integration
if @environment == "production"
  every "0 3 1 * *" do
    rake "audit:generate_monthly_snapshots"
  end
end

# You can check which cron jobs are will be loaded by runnig `$ whenever` or for development
# running `$ whenever --set environment='development'` to see which jobs will load in development.
# To load development only cron jobs use `whenever --update-crontab --set environment='development'`
# Run `env EDITOR=vim crontab -e` to view the crontab.
# Note I had difficult running this test task in development because RBENV was not loading
# correctly. I didn't bother bottoming out the issue as all the testing for this needs to be done
# later in a docker Linux instance using RVM.
# if @environment == "development"
#   every 15.minutes do
#     rake "audit:generate_monthly_snapshots"
#   end
# end
