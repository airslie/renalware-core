require_dependency "renalware/letters"

module Renalware
  module Letters
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :letters
      has_many :draft_letters, class_name: "Letter::Draft"
      belongs_to :doctor, class_name: "Renalware::Letters::Doctor"

      def cc_on_letter?(letter)
        return false unless letter.subject?(self)
        return false unless cc_on_all_letters?

        !letter.main_recipient.patient?
      end
    end
  end
end
