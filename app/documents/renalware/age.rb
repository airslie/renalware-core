module Renalware
  class Age < NestedAttribute
    attribute :amount, Integer
    attribute :unit, enums: %i(years months)

    validate :validate_unit

    def to_s
      amount.present? ? "#{amount} #{unit.try(:text)}" : ""
    end

    private

    def validate_unit
      return unless amount.present?
      if amount.to_i < 3 && unit.to_sym != :months
        errors.add(:unit, "Please enter age in amount of months")
      end
    end
  end
end