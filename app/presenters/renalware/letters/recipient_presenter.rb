require_dependency "renalware/letters"

module Renalware
  module Letters
    class RecipientPresenter < DumbDelegator
      def address
        if archived?
          super
        else
          case person_role
          when "patient"
            letter.patient.current_address
          when "doctor"
            letter.patient.doctor.current_address
          else
            super
          end
        end
      end

      def to_s
        address.to_s
      end
    end
  end
end
