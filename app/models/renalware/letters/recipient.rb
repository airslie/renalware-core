require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ActiveRecord::Base
      extend Enumerize

      belongs_to :letter
      has_one :address, as: :addressable

      enumerize :role, in: %i(main cc)
      enumerize :person_role, in: %i(patient doctor other)

      accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :patient_or_doctor?

      delegate :doctor?, :patient?, :other?, to: :person_role

      def to_s
        address.to_s
      end

      private

      def patient_or_doctor?
        patient? || doctor?
      end
    end
  end
end
