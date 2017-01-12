require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ApplicationRecord
      extend Enumerize

      belongs_to :letter
      belongs_to :addressee, polymorphic: true
      has_one :address, as: :addressable # for archiving purposes

      enumerize :role, in: %i(main cc)
      enumerize :person_role, in: %i(patient primary_care_physician contact)

      accepts_nested_attributes_for :address,
                                    allow_destroy: true,
                                    reject_if: :patient_or_primary_care_physician?

      validates_presence_of :addressee_id, if: :contact?

      delegate :primary_care_physician?, :patient?, :contact?, to: :person_role

      def to_s
        (address || current_address).to_s
      end

      def archive!
        build_address if address.blank?

        address.copy_from(current_address)
        address.save!
      end

      def current_address
        case
        when patient?
          letter.patient.current_address
        when primary_care_physician?
          letter.primary_care_physician.current_address
        else
          addressee.address
        end
      end

      def for_contact?(contact)
        return false unless person_role.contact?
        addressee_id == contact.id
      end

      private

      def patient_or_primary_care_physician?
        patient? || primary_care_physician?
      end
    end
  end
end
