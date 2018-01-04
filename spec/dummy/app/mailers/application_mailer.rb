class ApplicationMailer < ActionMailer::Base
  default from: ->{ Renalware.config.default_from_email_address }
  layout "mailer"
end
