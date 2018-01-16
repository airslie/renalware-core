require_dependency "renalware/feeds"

module Renalware
  module Feeds
    module Files
      module Practices
        class CountryMap
          UK_COUNTRIES = [
            "ENGLAND",
            "WALES",
            "SCOTLAND",
            "NORTHERN IRELAND"
          ].freeze

          class Country
            include Virtus.model
            attribute :region
            attribute :country
          end

          def map(country)
            return if country.blank?
            if UK_COUNTRIES.include?(country.upcase.strip)
              Country.new(country: "United Kingdom", region: country.strip.titleize)
            else
              Country.new(country: country)
            end
          end
        end
      end
    end
  end
end
