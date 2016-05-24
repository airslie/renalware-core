require_dependency "renalware/letters"
require_dependency "renalware/address_presenter"

module Renalware
  module Letters
    class RecipientPresenter < SimpleDelegator
      # We don't rely on `to_s` in this case as the string will not be marked as
      # HTML save if we leave it to be implicitly called in the template.
      #
      def to_html
        AddressPresenter::Block.new(address_for_person_role).to_html
      end

      def address
        AddressPresenter.new(address_for_person_role)
      end

      private

      def address_for_person_role
        __getobj__.address
      end

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
