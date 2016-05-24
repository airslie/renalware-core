require_dependency "renalware/address_presenter"

module Renalware
  class AddressPresenter::Block < AddressPresenter
    def to_s
      super.html_safe
    end

    private

    def join_arg
      "<br>"
    end

    def presentable_attrs
      [
        name,
        organisation_name,
        street_1,
        street_2,
        [city, county, postcode].reject(&:blank?).join(", "),
        country
      ]
    end
  end
end
