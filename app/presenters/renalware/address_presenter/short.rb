require_dependency "renalware/address_presenter"

module Renalware
  class AddressPresenter::Short < AddressPresenter
    private

    def presentable_attrs
      [street_1, postcode]
    end
  end
end
