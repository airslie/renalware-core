require_dependency "renalware"

module Renalware
  class AddressShortPresenter < SimpleDelegator
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
