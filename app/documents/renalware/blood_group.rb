module Renalware
  class BloodGroup < NestedAttribute
    OPTIONS = %w(A A+ A- B B+ B- AB AB+ AB- O O+ O-)

    attribute :value, String

    def to_s
      value
    end
  end
end

