module Renalware
  class BloodGroup < NestedAttribute
    attribute :value, String

    def self.valid_values
      %w(A B O AB)
    end

    def to_s
      value
    end
  end
end
