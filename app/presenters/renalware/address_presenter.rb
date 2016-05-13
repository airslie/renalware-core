require_dependency "renalware"

module Renalware
  class AddressPresenter < SimpleDelegator
    def on_one_line
      to_s
    end

    def short
      [street_1, postcode].reject(&:blank?).join(", ")
    end

    def on_one_line_without_name
      [street_1, street_2, city, county, postcode, country].reject(&:blank?).join(", ")
    end

    def in_a_block
      [
        name,
        organisation_name,
        street_1,
        street_2,
        [city, county, postcode].reject(&:blank?).join(", "),
        country
      ].reject(&:blank?).join("<br>").html_safe
    end

    def country
      no_country_if_uk(super)
    end

    def no_country_if_uk(country)
      ["UK", "United Kingdom"].include?(country) ? "" : country
    end
  end
end