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

      # @section sub-classes

      # The address for a recipient such as a doctor or a patient are denormalized
      # and stored with the recipient when the letter is archived. Before the
      # letter is archived, we display the current address directly from the
      # appropriate models ensuring the most recent address is presented.
      #
      class WithCurrentAddress < RecipientPresenter
        private

        def address_for_person_role
          case
          when patient?
            letter.patient.current_address
          when doctor?
            letter.doctor.current_address
          else
            __getobj__.address
          end
        end
      end
    end
  end
end
