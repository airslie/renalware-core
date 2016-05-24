require_dependency "renalware"

module Renalware
  class AddressPresenter < SimpleDelegator
    def to_s
      presentable_attrs
        .map(&:to_s)
        .reject(&:blank?)
        .join(join_arg)
    end

    def country
      ::Renalware::CountryPresenter.new(super)
    end

    private

    def join_arg
      ", "
    end

    def presentable_attrs
      [
        name,
        organisation_name,
        street_1,
        street_2,
        city,
        county,
        postcode,
        country
      ]
    end
  end
end
