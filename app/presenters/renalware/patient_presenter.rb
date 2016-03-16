require_dependency "renalware"

module Renalware
  class PatientPresenter < SimpleDelegator
    def address_line
      if current_address
        AddressPresenter.new(current_address).on_one_line
      end
    end

    def to_s
      super(:long)
    end
  end
end