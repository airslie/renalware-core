# frozen_string_literal: true

require "document/embedded"
require "document/enum"

module Renalware
  class PatientDocument < Document::Embedded
    attribute :interpreter_notes, String
    attribute :admin_notes, String
    attribute :special_needs_notes, String
    attribute :diabetes, DatedBooleanDiagnosis
    attribute :hiv, DatedBooleanDiagnosis
    attribute :hepatitis_b, DatedBooleanDiagnosis
    attribute :hepatitis_c, DatedBooleanDiagnosis

    class Referral < Document::Embedded
      attribute :referring_physician_name, String
      attribute :referral_date, Date
      attribute :referral_type, String
      attribute :referral_notes, String
    end
    attribute :referral, Referral

    class Psychosocial < Document::Embedded
      attribute :housing, String
      attribute :social_network, String
      attribute :care_package, String
      attribute :other, String
      attribute :updated_at, Date
    end
    attribute :psychosocial, Psychosocial

    class History < Document::Embedded
      attribute :alcohol, Document::Enum, enums: %i(never rarely social heavy)
      attribute :smoking, Document::Enum, enums: %i(no ex yes) # RRSMOKING %i(never former current)
    end
    attribute :history, History
  end
end
