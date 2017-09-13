require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class ElectronicReceiptPolicy < LetterPolicy
      def mark_as_read?
        record.letter.approved?
      end
    end
  end
end
