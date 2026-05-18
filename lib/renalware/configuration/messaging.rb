module Renalware
  class Configuration
    module Messaging
      def self.included(base)
        base.config_accessor(:messaging_recipient_warn_if_not_signed_in_for_days) do
          ActiveModel::Type::Integer.new.cast(
            ENV.fetch("MESSAGING_RECIPIENT_WARN_IF_NOT_SIGNED_IN_FOR_DAYS", 5)
          )
        end
      end
    end
  end
end
