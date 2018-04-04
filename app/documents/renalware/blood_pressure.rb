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
  end
end
