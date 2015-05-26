# Load the Rails application.
require File.expand_path('../application', __FILE__)

# TODO Heroku/Sendgrid specific config for acceptance testing environments.
# These will be superseded or based completely on environment vars.
#
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  :domain         => 'heroku.com',
  :enable_starttls_auto => true
}

# Initialize the Rails application.
Rails.application.initialize!
