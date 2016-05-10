require_dependency "renalware/letters"

module Renalware
  module Letters
    class Doctor < ActiveType::Record[Renalware::Doctor]
      def cc_on_letter?(letter)
        return false unless Letters.cast_doctor(letter.patient.doctor) == self
        letter.main_recipient.patient? || letter.main_recipient.outsider?
      end
    end
  end
end
