module Renalware
  class DatedTest < Document::Embedded
    attribute :result, enums: :test
    attribute :date, Date

    validates :date, timeliness: { type: :date, allow_blank: true }
  end
end