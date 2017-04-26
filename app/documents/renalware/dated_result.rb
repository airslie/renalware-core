module Renalware
  class DatedResult < NestedAttribute
    attribute :result
    attribute :recorded_on, Date

    validates :recorded_on, timeliness: { type: :date, allow_blank: true }

    def to_s
      datestamp = recorded_on.present? ? "(#{I18n.l(recorded_on)})" : nil
      [result, datestamp].compact.join(" ")
    end
  end

  # This class exists to let us use a different (non-table) *_input partial when rendering
  class DatedResult2 < DatedResult
  end
end
