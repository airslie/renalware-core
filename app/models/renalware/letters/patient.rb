require_dependency "renalware/letters"

module Renalware
  module Letters
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :letters

      def cc_on_letter?(letter)
        letter.patient == self && cc_on_all_letters?
      end
    end
  end
end
