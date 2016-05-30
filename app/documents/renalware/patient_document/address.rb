require "document/embedded"
require "document/enum"

module Renalware
  class PatientDocument < Document::Embedded
    class Address < Document::Embedded
      attribute :name, String
      attribute :organisation_name, String
      attribute :street_1, String
      attribute :street_2, String
      attribute :city, String
      attribute :county, String
      attribute :postcode, String
      attribute :country, String
    end
  end
end
