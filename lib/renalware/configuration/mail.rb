module Renalware
  class Configuration
    module Mail
      def self.included(base)
        register_delivery_settings(base)
        register_external_mail_settings(base)
        register_microsoft_oauth_settings(base)
        register_sendgrid_settings(base)
      end

      def self.register_delivery_settings(base)
        base.config_accessor(:mail_delivery_method) do
          ENV.fetch("MAIL_DELIVERY_METHOD", "microsoft_graph_api").to_sym
        end
      end

      def self.register_external_mail_settings(base)
        # Unless an ALLOW_EXTERNAL_MAIL key is present in .env or .env.production, mail
        # other than password reset emails etc will be redirected to e.g. the user who
        # approved the letter.
        base.config_accessor(:allow_external_mail) { ENV.key?("ALLOW_EXTERNAL_MAIL") }

        base.config_accessor(:fallback_email_address_for_test_messages) do
          ENV.fetch("FALLBACK_EMAIL_ADDRESS_FOR_TEST_MESSAGES", nil)
        end
      end

      def self.register_microsoft_oauth_settings(base)
        base.config_accessor(:mail_oauth_client_id) { ENV.fetch("MAIL_OAUTH_CLIENT_ID", nil) }
        base.config_accessor(:mail_oauth_client_secret) do
          ENV.fetch("MAIL_OAUTH_CLIENT_SECRET", nil)
        end
        base.config_accessor(:mail_oauth_tenant_id) { ENV.fetch("MAIL_OAUTH_TENANT_ID", nil) }
        base.config_accessor(:mail_oauth_email_address) do
          ENV.fetch("MAIL_OAUTH_EMAIL_ADDRESS", nil)
        end
      end

      def self.register_sendgrid_settings(base)
        base.config_accessor(:sendgrid_api_key) { ENV.fetch("SENDGRID_API_KEY", nil) }

        base.config_accessor(:sendgrid_email_address) do
          ENV["SENDGRID_EMAIL_ADDRESS"] ||
            ENV["MAIL_OAUTH_EMAIL_ADDRESS"] ||
            ENV.fetch("DEFAULT_FROM_EMAIL_ADDRESS", nil)
        end
      end
    end
  end
end
