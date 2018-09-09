# frozen_string_literal: true

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

      validates :addressee_id, presence: { if: :contact? }

      delegate :primary_care_physician?, :patient?, :contact?, to: :person_role

      def to_s
        (address || current_address).to_s
      end

      def archive!
        build_address if address.blank?

        address.copy_from(current_address)
        # Its possible a migrated address might not have a postcode. Don't let archiving fail
        # at this stage because of that as the user cannot be informed at this stage
        # so skip address validation.
        address.skip_validation = true

        address.save!
      end

      def current_address
        return address_for_patient if patient?
        return practice_address_for_patient if primary_care_physician?

        address_for_addressee_eg_contact
      end

      def for_contact?(contact)
        return false unless person_role.contact?

        addressee_id == contact.id
      end

      def statment_to_indicate_letter_will_be_emailed
        if primary_care_physician? && practice_email_address.present?
          "VIA EMAIL to #{practice_email_address}"
        end
      end

      private

      def address_for_patient
        letter.patient.current_address.tap do |address|
          ensure_address_has_a_name_required_when_displaying_letters(
            address,
            letter.patient.full_name
          )
        end
      end

      def practice_address_for_patient
        address = letter.patient&.practice&.address
        if address.present? && letter.primary_care_physician.present?
          ensure_address_has_a_name_required_when_displaying_letters(
            address,
            letter.primary_care_physician.to_s
          )
        end
        address
      end

      def address_for_addressee_eg_contact
        addressee.address.tap do |address|
          ensure_address_has_a_name_required_when_displaying_letters(
            address,
            addressee.respond_to?(:full_name) ? addressee.full_name : addressee.to_s
          )
        end
      end

      def patient_or_primary_care_physician?
        patient? || primary_care_physician?
      end

      def practice_email_address
        @practice_email_address ||= letter.patient&.practice&.email
      end

      # Make sure we have a 'name' set in the address record set as this is used in the letter
      # e.g. Roger Robar <- address.name
      #      123 Toon Town
      #      ...
      # Note address.name is a redundant field not consistently populated in the app
      # and should be removed. However its consumed in a quite a few places building letters
      # and displaying the letter form, hence this hack.
      def ensure_address_has_a_name_required_when_displaying_letters(address, name)
        address.name = name if address.present? && address.name.blank?
      end
    end
  end
end
