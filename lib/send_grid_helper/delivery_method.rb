require "send_grid_helper/client"

module SendGridHelper
  # Uses the SendGrid API to send an email from a specific configured email address.
  # Useful when an NHS Trust has disabled SMTP on a renalware NHSMail mailbox.
  class DeliveryMethod
    attr_accessor :settings

    def initialize(delivery_options)
      @settings = delivery_options
    end

    # Note this is a straightforward send with no opportunity to invoke before
    # and after hooks defined in delivery_options eg
    #   hook = delivery_options[:before_send] # or :after_send
    #   hook.call(mail, message) if hook.respond_to?(:call)
    # Supporting these would require us to first create a message in Drafts
    # using the API, then handle the before_send hook if there is one, send the
    # Draft message, and then handle any after_send hook. OTT to support unless
    # required.
    def deliver!(mail)
      client.send_mail(
        from: mail.from,
        to: mail.to,
        subject: mail.subject,
        body: mail.body.encoded,
        type: mail.mime_type&.downcase
      )
    end

    def client
      @client ||= Client.new(api_key: Renalware.config.sendgrid_api_key)
    end
  end
end
