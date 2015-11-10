module Renalware
  class BloodGroup < NestedAttribute
    attribute :value, enums: %i(a aplus aminus b bplus bminus ab abplus abminus o oplus ominus)

    def to_s
      value.try(:text)
    end
  end
end