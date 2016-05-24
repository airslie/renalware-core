require_dependency "renalware"

module Renalware
  class AddressPresenter < SimpleDelegator
    def on_one_line
      to_s
    end

    def short
      [street_1, postcode].reject(&:blank?).join(", ")
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
  end
end
