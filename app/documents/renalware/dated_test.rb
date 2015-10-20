module Renalware
  class DatedTest < NestedAttribute
    attribute :result, enums: %i(negative positive not_done)
    attribute :date, Date

    validates :date, timeliness: { type: :date, allow_blank: true }

    def to_s
      datestamp = date.present? ? "(#{I18n.l(date)})" : nil
      [result.try(:text), datestamp].compact.join(" ")
    end
  end
end