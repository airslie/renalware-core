require_dependency "renalware"
require_dependency "renalware/address_presenter"

module Renalware
  class PrimaryCarePhysicianPresenter < SimpleDelegator
    def address
      AddressPresenter.new(current_address)
    end

    def salutation
      [title, family_name].join(" ")
    end
  end
end
