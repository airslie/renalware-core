require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ActiveRecord::Base
      belongs_to :letter
      belongs_to :source, polymorphic: true
      has_one :address, as: :addressable

      accepts_nested_attributes_for :address, reject_if: :address_not_needed?, allow_destroy: true

      after_initialize :apply_defaults, if: :new_record?
      before_save :assign_doctor_or_patient

      private

      def address_not_needed?
        source_type.present?
      end

      def apply_defaults
        self.source_type ||= Doctor.name
      end

      def assign_doctor_or_patient
        case source_type
        when "Renalware::Doctor"
          self.source_id = letter.patient.doctor_id
        when "Renalware::Patient"
          self.source_id = letter.patient_id
        end
      end
    end
  end
end
