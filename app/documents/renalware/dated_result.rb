module Renalware
  class DatedResult < Document::Embedded
    attribute :result
    attribute :date, Date

    validates :date, timeliness: { type: :date, allow_blank: true }
  end
end