require_dependency "renalware/letters"

module Renalware
  module Letters
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :letters
      belongs_to :primary_care_physician, class_name: "Renalware::Letters::PrimaryCarePhysician"

      def cc_on_letter?(letter)
        return false unless letter.subject?(self)
        return false unless cc_on_all_letters?

        !letter.main_recipient.patient?
      end
    end
  end
end
