require_dependency "renalware"

module Renalware
  class AddressSingleLinePresenter < SimpleDelegator
    def to_s
      [street_1, street_2, city, county, postcode, country].reject(&:blank?).join(", ")
    end

    def country
      no_country_if_uk(super)
    end

    private

    def no_country_if_uk(country)
      ["UK", "United Kingdom"].include?(country) ? "" : country
    end
  end
end
