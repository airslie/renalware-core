require_dependency "renalware"

module Renalware
  module Letters
    module ActsAsLetterRecipient
      extend ActiveSupport::Concern

      included do
        has_many :recipients, as: :source
      end

      def recipients_in_pending_letter
        recipients.joins(:letter).where("letter_letters.state != ?", "archived")
      end
    end
  end
end
