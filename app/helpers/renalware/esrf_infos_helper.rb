module Renalware
  module ESRFInfosHelper
    def display_prd_diagnosed_on(patient)
      patient.try(:esrf).try(:diagnosed_on)
    end

    def display_prd(patient)
      patient.try(:esrf).try(:prd_code).try(:term)
    end
  end
end
