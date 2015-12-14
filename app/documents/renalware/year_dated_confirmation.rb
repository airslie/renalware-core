module Renalware
  class YearDatedConfirmation < NestedAttribute
    attribute :status, enums: %i(yes no unknown)
    attribute :confirmed_on_year, Integer

    validates :confirmed_on_year, numericality: { allow_blank: true, only_integer: true }
    validates :confirmed_on_year, presence: true, if: ->(o) { o.status.try(:yes?) }

    def self.valid_years
      (1900..Time.zone.today.year).to_a
    end

    def to_s
      datestamp = confirmed_on_year.present? ? "(#{confirmed_on_year})" : nil
      [status.try(:text), datestamp].compact.join(" ")
    end
  end
end