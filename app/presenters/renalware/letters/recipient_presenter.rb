require_dependency "renalware/letters"
require_dependency "renalware/address_presenter"

module Renalware
  module Letters
    class RecipientPresenter < SimpleDelegator
      def to_s
        AddressPresenter::Block.new(address_for_person_role).to_s
      end

      def address
        AddressPresenter.new(address_for_person_role)
      end

      private

      def address_for_person_role
        __getobj__.address
      end

      public

      class Draft < RecipientPresenter
        private

        def address_for_person_role
          case person_role
          when "patient"
            letter.patient.current_address
          when "doctor"
            letter.patient.doctor.current_address
          else
            __getobj__.address
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
