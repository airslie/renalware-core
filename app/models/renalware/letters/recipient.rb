require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ActiveRecord::Base
      extend Enumerize

      belongs_to :letter
      has_one :address, as: :addressable

      enumerize :role, in: %i(main cc)
      enumerize :person_role, in: %i(patient doctor outsider)

      accepts_nested_attributes_for :address, reject_if: :insider?, allow_destroy: true

      delegate :state, to: :letter

      def to_s
        address.to_s
      end

      def archived?
        state.archived?
      end

      def insider?
        doctor? || patient?
      end

      def doctor?
        person_role.doctor?
      end

      def patient?
        person_role.patient?
      end

      def outsider?
        person_role.outsider?
      end
    end
  end
end
