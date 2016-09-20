module Renalware
  module Patients
    class TemperatureValidator < ActiveModel::EachValidator
      MIN_TEMP = 28.0
      MAX_TEMP = 45.0

      def validate_each(record, attribute, value)
        return if value.blank?
        validate_number(record, attribute, value)
        validate_number_is_in_range(record, attribute, value)
      end

      private

      def validate_number(record, attribute, value)
        if weight_has_more_than_one_decimal_place?(value)
          record.errors.add(attribute, :invalid_number)
        end
      end

      def validate_number_is_in_range(record, attribute, value)
        weight = value.to_f.round(1)
        if weight < MIN_TEMP || weight > MAX_TEMP
          record.errors.add(attribute, :out_of_range)
        end
      end

      # Returns true for any integer or number to one decimal place
      # e.g. 11 or 11.1 but not 11.11
      def weight_has_more_than_one_decimal_place?(value)
        value.to_f.round(1) != value.to_f
      end
    end
  end
end
