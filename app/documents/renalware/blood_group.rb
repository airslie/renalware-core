module Renalware
  class BloodGroup < NestedAttribute
    attribute :group, Document::Enum, enums: %i(A B O AB)
    attribute :rhesus, Document::Enum, enums: %i(positive negative)

    def to_s
      "#{group&.text} #{rhesus&.text}".strip
    end
  end
end
