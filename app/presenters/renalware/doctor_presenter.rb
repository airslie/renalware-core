require_dependency "renalware"
require_dependency "renalware/address_presenter"

module Renalware
  class DoctorPresenter < SimpleDelegator
    def address
      AddressPresenter.new(super || practice_address)
    end
  end
end
