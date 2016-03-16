require_dependency "renalware"

module Renalware
  class DoctorPresenter < SimpleDelegator
    def address_line
      Renalware::AddressPresenter.new(address || practice_address).on_one_line
    end
  end
end