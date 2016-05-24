require_dependency "renalware/address_presenter"

module Renalware
  class AddressShortPresenter < AddressPresenter
    def short
      presentable_attrs
        .reject(&:blank?)
        .join(", ")
    end

    private

    def presentable_attrs
      [street_1, postcode]
    end
  end
end
