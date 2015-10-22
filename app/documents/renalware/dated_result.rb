module Renalware
  class DatedResult < NestedAttribute
    attribute :result
    attribute :date, Date

    validates :date, timeliness: { type: :date, allow_blank: true }

    def to_s
      datestamp = date.present? ? "(#{I18n.l(date)})" : nil
      [result, datestamp].compact.join(" ")
    end
  end
end