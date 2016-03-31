require_dependency "renalware/letters"

module Renalware
  module Letters
    class CCRecipient < Recipient
      def automatic?
        source_type.present?
      end
    end
  end
end
