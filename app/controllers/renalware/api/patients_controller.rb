require_dependency "renalware/api"

module Renalware
  module API
    class PatientsController < TokenAuthenticatedApiController
      def show
        render json: Patient.find(1)
      end
    end
  end
end
