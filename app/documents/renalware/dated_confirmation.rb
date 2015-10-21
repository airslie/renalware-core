module Renalware
  class DatedConfirmation < NestedAttribute
    attribute :status, enums: %i(yes no unknown)
    attribute :date, Date

    validates :date, timeliness: { type: :date, allow_blank: true }
    validates :date, presence: true, if: "status.try(:yes?)"

    def to_s
      datestamp = date.present? ? "(#{I18n.l(date)})" : nil
      [status.try(:text), datestamp].compact.join(" ")
    end
  end
end