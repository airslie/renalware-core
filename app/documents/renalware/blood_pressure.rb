# frozen_string_literal: true

module Renalware
  class BloodPressure < NestedAttribute
    attribute :systolic, Integer
    attribute :diastolic, Integer

    validates :systolic, numericality: { allow_blank: true }
    validates :diastolic, numericality: { allow_blank: true }
    validates_with Renalware::Patients::BloodPressureValidator

    def to_s
      return "" unless systolic.present? && diastolic.present?

      "#{systolic} / #{diastolic}"
    end

    def blank?
      systolic.blank? && diastolic.blank?
    end

    # In order to compare 2 BloodPressure value objects add diastolic and systolic together
    # and compare the result
    def <=>(other)
      to_i <=> other.to_i
    end

    def to_i
      return 1_000_000 if (systolic.to_i + diastolic.to_i).zero?

      systolic.to_i + diastolic.to_i
    end
  end
end
