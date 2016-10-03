require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ActiveRecord::Base
      extend Enumerize

      belongs_to :letter
      has_one :address, as: :addressable

      enumerize :role, in: %i(main cc)
      enumerize :person_role, in: %i(patient primary_care_physician other)

      accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :patient_or_primary_care_physician?

      delegate :primary_care_physician?, :patient?, :other?, to: :person_role

      def to_s
        address.to_s
      end

      def archive!
        return if address.present?

        build_address.tap do |address|
          address.copy_from(address_for_person_role)
          address.save!
        end
      end

      def address_for_person_role
        case
        when patient?
          letter.patient.current_address
        when primary_care_physician?
          letter.primary_care_physician.current_address
        else
          address
        end
      end

      private

      def patient_or_primary_care_physician?
        patient? || primary_care_physician?
      end
    end
  end
end
