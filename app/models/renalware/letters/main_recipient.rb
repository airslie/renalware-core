require_dependency "renalware/letters"

module Renalware
  module Letters
    class MainRecipient < Recipient
      def is_doctor?
        source_type == "Renalware::Doctor"
      end

      def is_patient?
        source_type == "Renalware::Patient"
      end
    end
  end
end
