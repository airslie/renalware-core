module Renalware
  module Patients
    class BookmarksController < BaseController
      before_action :load_patient
      before_action :load_bookmark

      def create
        patient = Renalware::Patient.find(params[:patient_id])
        Renalware::Patients::Bookmark.create(user: current_user, patient: patient)

        redirect_to patient_path(id: patient.id), notice: t(".success", model_name: "bookmark")
      end
    end
  end
end
