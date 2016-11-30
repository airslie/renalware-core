module Renalware
  module PatientHelper
    def formatted_nhs_number(patient)
      PatientPresenter.new(patient).nhs_number
    end
  end
end
