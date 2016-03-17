require_dependency "renalware"

module Renalware
  class PatientPresenter < SimpleDelegator
    def address_line
      return if current_address.blank?

      AddressPresenter.new(current_address).on_one_line
    end

    def to_s
      super(:long)
    end
  end
end