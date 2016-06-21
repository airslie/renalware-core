module Renalware
  module Patients
    class BookmarksController < BaseController
      before_action :load_patient, only: :create

      def create
        Renalware::Patients::Bookmark.create(user: current_user, patient: @patient)

        redirect_to patient_path(id: @patient.id), notice: t(".success", model_name: "bookmark")
      end

      def destroy
        bookmark = Renalware::Patients::Bookmark.find(params[:id])
        authorize bookmark

        bookmark.destroy
        redirect_to patient_path(bookmark.patient_id),
          notice: t(".success", model_name: "bookmark")
      end
    end
  end
end
