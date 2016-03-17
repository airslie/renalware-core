require_dependency "renalware/letters"

module Renalware
  module Letters
    class MainRecipient < Recipient

      after_initialize :apply_defaults, if: :new_record?

      private

      def apply_defaults
        self.source_type ||= Doctor.name
      end
    end
  end
end
