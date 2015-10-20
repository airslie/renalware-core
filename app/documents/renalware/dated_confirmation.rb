module Renalware
  class DatedConfirmation < NestedAttribute
    attribute :status, enums: %i(yes no unknown)
    attribute :date, Date

    validates :date, timeliness: { type: :date, allow_blank: true }
    validates :date, presence: true, if: "status.try(:yes?)"
  end
end