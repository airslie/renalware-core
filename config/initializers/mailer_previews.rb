# Enable mailer previews in Staging
#
if Rails.env.staging?
  class ::Rails::MailersController
    def local_request?
      true
    end
  end
end
