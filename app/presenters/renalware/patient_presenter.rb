module Renalware
  class PatientPresenter < SimpleDelegator
    def address_line
      if current_address
        current_address.to_s(:street_1, :street_2, :city, :county, :postcode, :country)
      end
    end

    def to_s
      super(:long)
    end
  end
end