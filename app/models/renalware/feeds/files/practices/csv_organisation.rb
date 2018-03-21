# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    module Files
      module Practices
        class CSVOrganisation
          include Virtus.model
          attribute :code, String
          attribute :name, String
          attribute :telephone, String
          attribute :street_1, String
          attribute :street_2, String
          attribute :street_3, String
          attribute :city, String
          attribute :county, String
          attribute :postcode, String
          attribute :region, String # used to capture England, Wales etc
          attribute :country_id, Integer # will normally be id for United Kingdom country
          attribute :roles
          attribute :active
          attribute :skip, Boolean

          def self.headers
            attribute_set.map(&:name) - [:roles, :skip]
          end

          def to_a
            self.class.headers.map{ |key| public_send(key) }
          end
        end
      end
    end
  end
end
