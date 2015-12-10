module Renalware
  class BloodGroup < NestedAttribute
    attribute :value, String

    def self.valid_values
      %w(A A+ A- B B+ B- AB AB+ AB- O O+ O-)
    end

    def to_s
      value
    end
  end
end

