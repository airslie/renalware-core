require_dependency "renalware/letters"

module Renalware
  module Letters
    class PrimaryCarePhysician < ActiveType::Record[Renalware::Patients::PrimaryCarePhysician]
      has_many :patients
      has_many :letters, through: :patients

      def cc_on_letter?(letter)
        return false unless letter.patient.assigned_to_primary_care_physician?(self)
        letter.main_recipient.patient? || letter.main_recipient.other?
      end
    end
  end
end
