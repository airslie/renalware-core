require_dependency "renalware/letters"

module Renalware
  module Letters
    class RecipientPresenter < SimpleDelegator
      def to_s
        ::Renalware::AddressBlockPresenter.new(address_for_person_role(super)).to_s
      end

      def address_line
        address.to_s
      end

      def address
        ::Renalware::AddressPresenter.new(address_for_person_role(super))
      end

      def address_for_person_role(address)
        address
      end

      class Draft < RecipientPresenter
        def address_for_person_role(address)
          case person_role
          when "patient"
            letter.patient.current_address
          when "doctor"
            letter.patient.doctor.current_address
          else
            address
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
