require_dependency "renalware/letters"

module Renalware
  module Letters
    class CCRecipient < Recipient
      scope :manual, -> { where(source_type: nil) }

      def automatic?
        source_type.present?
      end
    end
  end
end
