module Renalware
  class BloodPressure < NestedAttribute
    attribute :systolic, Integer
    attribute :diastolic, Integer

    def to_s
      "#{systolic}/#{diastolic}"
    end
  end
end

