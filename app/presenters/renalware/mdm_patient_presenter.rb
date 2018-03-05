# frozen_string_literal: true

module Renalware
  # Presenter formatting a single patient for use behind any MDM Patients listing.
  class MDMPatientPresenter < PatientPresenter
    def esrf_date
      Renalware::Renal.cast_patient(__getobj__).profile&.esrf_on
    end

    def current_observation_set
      @current_observation_set ||= begin
        Renalware::Pathology::ObservationSetPresenter.new(__getobj__.current_observation_set)
      end
    end
  end
end
