require_dependency "renalware/letters"

module Renalware
  module Letters
    class Doctor < ActiveType::Record[Renalware::Doctor]
      has_many :reviewable_letters, class_name: "Letter::Typed"

      def cc_on_letter?(letter)
        return false unless letter.patient.assigned_to_doctor?(self)
        letter.main_recipient.patient? || letter.main_recipient.other?
      end
    end
  end
end
