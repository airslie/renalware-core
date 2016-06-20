module Renalware
  class BookmarksController < BaseController
    before_action :load_patient

    def create
      patient = Renalware::Patient.find(params[:patient_id])
      bookmark = Renalware::Patients::Bookmark.new(user: current_user, patient: patient)

      redirect_to patient_path(id: patient.id), notice: t(".success", model_name: "bookmark")
    end
  end
end
