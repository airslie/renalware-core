require_dependency("renalware/renal")
require "collection_presenter"

module Renalware
  module Renal
    class RegistryPreflightChecksController < BaseController
      include Renalware::Concerns::Pageable

      class PatientPresenter < SimpleDelegator
        def missing_data
          Registry::PreflightChecks::PatientsQuery.missing_data_for(__getobj__)
        end

        def hd_unit
          if current_modality.description.name == "HD"
            Renalware::HD.cast_patient(__getobj__)&.hd_profile&.hospital_unit&.unit_code
          end
        end
      end

      class DeceasedPatientPresenter < SimpleDelegator
        def missing_data
          Registry::PreflightChecks::DeathsQuery.missing_data_for(__getobj__)
        end

        def hd_unit; end
      end

      def patients
        authorize [:renalware, :renal, :registry_preflight_check], :patients?
        patients = Registry::PreflightChecks::PatientsQuery.new.call.page(page).per(per_page)
        patients = CollectionPresenter.new(patients, PatientPresenter)
        render locals: { patients: patients }
      end

      def deaths
        authorize [:renalware, :renal, :registry_preflight_check], :deaths?
        patients = Registry::PreflightChecks::DeathsQuery.new.call.page(page).per(per_page)
        patients = CollectionPresenter.new(patients, DeceasedPatientPresenter)
        render locals: { patients: patients }
      end
    end
  end
end
