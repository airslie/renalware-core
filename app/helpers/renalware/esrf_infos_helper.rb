module Renalware
  module ESRFInfosHelper
    def display_prd_date(patient)
      patient.try(:esrf).try(:date)
    end

    def display_prd(patient)
      patient.try(:esrf).try(:prd_code).try(:term)
    end
  end
end
