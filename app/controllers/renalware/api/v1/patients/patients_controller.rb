require_dependency "renalware/patients"
require_dependency "renalware/api"

module Renalware
  module API
    module V1
      module Patients
        class PatientsController < TokenAuthenticatedApiController
          def show
            patient = Patient.find_by!(local_patient_id: params[:id])
            render locals: { patient: patient }
          end
        end
      end
    end
  end
end
