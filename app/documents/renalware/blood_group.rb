module Renalware
  class BloodGroup < NestedAttribute
    attribute :group
    attribute :rhesus, Document::Enum, enums: %i(positive negative)

    def to_s
      [group_name, rhesus&.text].compact_blank.join(" ")
    end

    private

    def group_name
      return if group.blank?

      BloodGroupDescription.find_by(code: group)&.name || group
    end
  end
end
