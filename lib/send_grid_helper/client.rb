require "sendgrid-ruby"

module SendGridHelper
  class Client
    def initialize(api_key:)
      @api_key = api_key
    end

    def send_mail(from:, to:, subject:, body:, type:)
      from = SendGrid::Email.new(email: from.first)
      to = SendGrid::Email.new(email: to.first)
      content = SendGrid::Content.new(type:, value: body)
      mail = SendGrid::Mail.new(from, subject, to, content)

      sg = SendGrid::API.new(api_key: @api_key)
      sg.client.mail._("send").post(request_body: mail.to_json)
    end

    private

    attr_reader :api_key
  end
end
