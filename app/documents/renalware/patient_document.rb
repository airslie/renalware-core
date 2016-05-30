require "document/embedded"
require "document/enum"

module Renalware
  class PatientDocument < Document::Embedded
    attribute :interpreter_notes, String
    attribute :admin_notes, String
    attribute :special_needs_notes, String

    class NextOfKin < Document::Embedded
      attribute :name, String
      attribute :telephone, String
      attribute :address, Address
    end
    attribute :next_of_kin, NextOfKin

    class Pharmacist < Document::Embedded
      attribute :name, String
      attribute :telephone, String
      attribute :address, Address
    end
    attribute :pharmacist, Pharmacist

    class DistinctNurse < Document::Embedded
      attribute :name, String
      attribute :telephone, String
      attribute :address, Address
    end
    attribute :distinct_nurse, DistinctNurse

    class Referral < Document::Embedded
      attribute :referring_physician_name, String
      attribute :referral_date, Date
      attribute :referral_type, String
      attribute :referral_notes, String
    end
    attribute :referral, Referral
  end
end
