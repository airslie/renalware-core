module Renalware
  class DatedTest < NestedAttribute
    attribute :result, enums: :test
    attribute :date, Date

    validates :date, timeliness: { type: :date, allow_blank: true }
  end
end