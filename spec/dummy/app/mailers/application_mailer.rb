class ApplicationMailer < ActionMailer::Base
  default from: Renalware.config.default_from_email
  layout "mailer"
end
