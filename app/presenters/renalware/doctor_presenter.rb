require_dependency "renalware"

module Renalware
  class DoctorPresenter < SimpleDelegator
    def address
      Renalware::AddressPresenter.new(super || practice_address)
    end
  end
end
