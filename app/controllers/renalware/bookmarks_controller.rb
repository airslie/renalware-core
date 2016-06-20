module Renalware
  class BookmarksController < BaseController
    before_action :load_patient

    def create
      patient = Renalware::Patient.find(params[:patient_id])
      bookmark = Renalware::Patients::Bookmark.new(user: current_user, patient: patient)

      url = patient_path(id: patient.id)
      if bookmark.save
        redirect_to url, notice: t(".success", model_name: "bookmark")
      else
        redirect_to url, notice: t(".failed", model_name: "bookmark")
      end
    end
  end
end
