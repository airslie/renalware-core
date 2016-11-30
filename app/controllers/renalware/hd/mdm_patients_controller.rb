require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class MDMPatientsController < BaseController
      include PresenterHelper

      def index
        patients = MDMPatientsQuery.call.page(params[:page]).per(50)
        authorize patients
        render :index, locals: {
          patients: present(patients, PatientPresenter)
        }
      end
    end
  end
end
