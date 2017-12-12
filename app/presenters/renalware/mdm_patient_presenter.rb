module Renalware
  # Presenter formatting a single patient for use behind any MDM Patients listing.
  class MDMPatientPresenter < PatientPresenter
    def esrf_date
      Renalware::Renal.cast_patient(__getobj__).profile&.esrf_on
    end
  end
end
