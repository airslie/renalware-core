module Renalware
  class DatedResult < NestedAttribute
    attribute :result
    attribute :date, Date

    validates :date, timeliness: { type: :date, allow_blank: true }
  end
end