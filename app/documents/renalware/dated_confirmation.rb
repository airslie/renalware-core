module Renalware
  class DatedConfirmation < Document::Embedded
    attribute :status, enums: :confirmation
    attribute :date, Date

    validates :date, timeliness: { type: :date, allow_blank: true }
    validates :date, presence: true, if: "status.try(:yes?)"
  end
end