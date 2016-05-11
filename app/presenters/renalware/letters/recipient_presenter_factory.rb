require_dependency "renalware/letters"

module Renalware
  module Letters
    class RecipientPresenterFactory
      def self.new(recipient)
        RecipientPresenter.const_get(recipient.state.classify).new(recipient)
      end
    end

    class RecipientPresenter < DumbDelegator
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
