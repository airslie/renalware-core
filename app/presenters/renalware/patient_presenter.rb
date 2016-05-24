require_dependency "renalware"
require_dependency "renalware/address_presenter/single_line"

module Renalware
  class PatientPresenter < SimpleDelegator
    def address
      AddressPresenter::SingleLine.new(current_address)
    end

    def to_s
      super(:long)
    end
  end
end
