module Renalware
  class BloodPressure < NestedAttribute
    attribute :systolic, Integer
    attribute :diastolic, Integer

    validates_with Renalware::Patients::BloodPressureValidator

    def to_s
      return "" unless systolic.present? && diastolic.present?
      "#{systolic} / #{diastolic}"
    end

    def blank?
      systolic.blank? && diastolic.blank?
    end
  end
end
