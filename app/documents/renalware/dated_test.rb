module Renalware
  class DatedTest < NestedAttribute
    attribute :result, enums: %i(negative positive not_done)
    attribute :date, Date

    validates :date, timeliness: { type: :date, allow_blank: true }
  end
end