require_dependency "renalware"

module Renalware
  class AddressPresenter < SimpleDelegator
    def on_one_line
      [street_1, street_2, city, county, postcode, country].reject(&:blank?).join(", ")
    end

    def street_1_and_postcode
      [street_1, postcode].reject(&:blank?).join(", ")
    end
  end
end