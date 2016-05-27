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

      class Address < Document::Embedded
        attribute :name, String
        attribute :organisation_name, String
        attribute :street_1, String
        attribute :street_2, String
        attribute :city, String
        attribute :county, String
        attribute :postcode, String
      end
      attribute :address, Address
    end
    attribute :next_of_kin, NextOfKin
  end
end
