module Renalware
  # Presenter formatting a single patient for use behind any MDM Patients listing.
  class MDMPatientPresenter < PatientPresenter
    delegate :hgb_result,
             :hgb_observed_at,
             :ure_result,
             :ure_observed_at,
             :cre_result,
             :cre_observed_at,
             :mdrd_result,
             :mdrd_observed_at,
             to: :current_key_observation_set, allow_nil: true

    def esrf_date
      Renalware::Renal.cast_patient(__getobj__).profile&.esrf_on
    end
  end
end
