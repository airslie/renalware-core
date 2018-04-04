require_dependency "renalware/patients"
require_dependency "renalware/api"

module Renalware
  module API
    module V1
      module Patients
        class PatientsController < TokenAuthenticatedApiController
          include Concerns::Pageable

          def show
            patient = Patient.find_by!(local_patient_id: params[:id])
            render locals: { patient: patient }
          end

          def index
            render locals: { patients: patients }
          end

          private

          def patients
            relation = last_patient_id.blank? ? Patient.none : Patient
            relation
              .where("id > ?", last_patient_id)
              .order(id: :asc)
              .page(page).per(per_page)
          end

          def last_patient_id
            params[:last_patient_id]
          end
        end
      end
    end
  end
end
