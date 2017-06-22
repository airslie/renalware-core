require "document/embedded"
require "document/enum"

module Renalware
  class PatientDocument < Document::Embedded
    attribute :interpreter_notes, String
    attribute :admin_notes, String
    attribute :special_needs_notes, String

    class Diabetes < NestedAttribute
      attribute :diagnosis, Boolean
      attribute :diagnosed_on, Date

      validates :diagnosed_on, timeliness: { type: :date, allow_blank: true }
    end
    attribute :diabetes, Diabetes

    # TODO: Check if this is used?
    class Address < Document::Embedded
      attribute :name, String
      attribute :organisation_name, String
      attribute :street_1, String
      attribute :street_2, String
      attribute :street_3, String
      attribute :town, String
      attribute :county, String
      attribute :postcode, String
      attribute :country, String
    end

    class Referral < Document::Embedded
      attribute :referring_physician_name, String
      attribute :referral_date, Date
      attribute :referral_type, String
      attribute :referral_notes, String
    end
    attribute :referral, Referral

    class History < Document::Embedded
      attribute :alcohol, Document::Enum, enums: %i(never rarely social heavy)
      attribute :smoking, Document::Enum, enums: %i(never former current)
    end
    attribute :history, History
  end
end
