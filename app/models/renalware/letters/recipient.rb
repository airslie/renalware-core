require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ActiveRecord::Base
      belongs_to :letter
      belongs_to :source, polymorphic: true
      has_one :address, as: :addressable

      accepts_nested_attributes_for :address, reject_if: :from_source?, allow_destroy: true

      scope :with_source, -> { where.not(source_type: nil) }

      def to_s
        [name, address].compact.map(&:to_s).join(", ")
      end

      def manual?
        # Note: if the recipient does not have a source, it is a "manually typed" recipient
        # Otherwise, it is either a Doctor or a Patient
        source_type.blank?
      end

      def from_source?
        !manual?
      end

      def doctor?
        source_type == "Renalware::Doctor"
      end

      def patient?
        source_type == "Renalware::Patient"
      end

      def assign_source!
        return if manual?

        case
        when patient?
          self.source = letter.patient
        when doctor?
          self.source = letter.patient.doctor
        else
          raise "Unknown source_type #{source_type}"
        end

        save
      end
    end
  end
end
