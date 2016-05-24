require_dependency "renalware"

module Renalware
  class AddressBlockPresenter < SimpleDelegator
    def to_html
      presentable_attrs
        .map(&:to_s)
        .reject(&:blank?)
        .join("<br>")
        .html_safe
    end

    private

    def presentable_attrs
      [
        name,
        organisation_name,
        street_1,
        street_2,
        [city, county, postcode].reject(&:blank?).join(", "),
        ::Renalware::CountryPresenter.new(country)
      ]
    end
  end
end
