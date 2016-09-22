module Renalware
  module Patients
    class BloodPressureValidator < ActiveModel::Validator
      include NumericRangeValidations
      MIN_VALUE = 20
      MAX_VALUE = 300

      def validate(record)
        return if record.systolic.blank? && record.diastolic.blank?
        validate_number_is_in_range(record, :systolic, record.systolic, MIN_VALUE, MAX_VALUE)
        validate_number_is_in_range(record, :diastolic, record.diastolic, MIN_VALUE, MAX_VALUE)
        validate_diastolic_less_than_systolic(record)
      end

      def validate_diastolic_less_than_systolic(record)
        return if record.errors.any?
        unless record.diastolic < record.systolic
          record.errors.add(:diastolic, :must_be_less_than_systolic)
        end
      end
    end
  end
end
