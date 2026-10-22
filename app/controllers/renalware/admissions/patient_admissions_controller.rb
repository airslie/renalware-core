require "collection_presenter"

module Renalware
  module Admissions
    class PatientAdmissionsController < BaseController
      def index
        _pagy, admissions = pagy(
          Admission.where(patient_id: patient.id).order(admitted_on: :desc),
          limit: PageSize.parse(params[:per_page], default: 20)
        )
        authorize admissions
        render locals: {
          admissions: CollectionPresenter.new(admissions, AdmissionPresenter)
        }
      end
    end
  end
end
