require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ActiveRecord::Base
      extend Enumerize

      belongs_to :letter
      belongs_to :addressee, polymorphic: true
      has_one :address, as: :addressable # for archiving purposes

      enumerize :role, in: %i(main cc)
      enumerize :person_role, in: %i(patient primary_care_physician contact)

      accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :patient_or_primary_care_physician?

      delegate :primary_care_physician?, :patient?, :contact?, to: :person_role

      attr_accessor :contact_id

      before_validation :assign_addressee

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

      private

      def patient_or_primary_care_physician?
        patient? || primary_care_physician?
      end

      def assign_addressee
        return if role.cc?

        assign_addressee_from_contact_id
      end

      def assign_addressee_from_contact_id
        if contact_id.present?
          self.addressee = Contact.find(contact_id)
        else
          self.addressee = nil
        end
      end
    end
  end
end
