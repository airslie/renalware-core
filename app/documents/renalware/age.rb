require "age_computation"

module Renalware
  class Age < NestedAttribute
    attribute :amount, Integer
    attribute :unit, enums: %i(years months)

    validate :validate_unit

    def to_s
      amount.present? ? "#{amount} #{unit.try(:text)}" : ""
    end

    def set_from_dates(born_on, current_date)
      if current_date.present? && born_on.present?
        age = birthday_age(born_on, current_date)
        if age[:years] >= 3
          self.amount = age[:years]
          self.unit = :years
        else
          self.amount = age[:years] * 12 + age[:months]
          self.unit = :months
        end
      end
    end

    private

    def validate_unit
      return unless amount.present?
      if amount.to_i < 3 && unit.to_sym != :months
        errors.add(:unit, :invalid_unit)
      end
    end
  end
end