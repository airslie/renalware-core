module Renalware
  # Presenter formatting a single patient for use behind any MDM Patients listing.
  class MDMPatientPresenter < PatientPresenter
    delegate :result, :observed_at, to: :hgb, prefix: true, allow_nil: true
    delegate :result, :observed_at, to: :cre, prefix: true, allow_nil: true
    delegate :result, :observed_at, to: :ure, prefix: true, allow_nil: true
    delegate :result, :observed_at, to: :mdrd, prefix: true, allow_nil: true

    def esrf_date
      Renalware::Renal.cast_patient(__getobj__).profile&.esrf_on
    end

    private

    def hgb
      current_pathology_result_for_code("HGB")
    end

    def ure
      current_pathology_result_for_code("URE")
    end

    def cre
      current_pathology_result_for_code("CRE")
    end

    def mdrd
      current_pathology_result_for_code("MDRD")
    end

    def current_pathology_result_for_code(code)
      current_pathology.detect { |path| path&.description&.code == code }
    end

    def current_pathology
      @current_pathology ||= begin
        Pathology::CurrentObservationsForDescriptionsQuery
          .new(patient: __getobj__, descriptions: Pathology::RelevantObservationDescription.all)
          .call
      end
    end
  end
end
