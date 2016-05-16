require_dependency "renalware/letters"

module Renalware
  module Letters
    class RecipientPresenter < SimpleDelegator
      def to_s
        address.to_s
      end

      class Draft < RecipientPresenter
        def address
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

      class ReadyForReview < Draft
      end

      class Archived < RecipientPresenter
      end
    end
  end
end
