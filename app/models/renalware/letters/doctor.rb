require_dependency "renalware/letters"

module Renalware
  module Letters
    class Doctor < ActiveType::Record[Renalware::Doctor]
      def cc_on_letter?(letter)
        return false unless assigned_to?(letter.patient)
        letter.main_recipient.patient? || letter.main_recipient.other?
      end

      def assigned_to?(patient)
        patient.doctor == self
      end
    end
  end
end
