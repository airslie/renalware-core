module Renalware
  module Patients
    class BookmarksController < BaseController
      before_action :load_patient, only: :create

      def create
        patients_user.bookmarks.create!(patient: @patient)

        redirect_to patient_path(id: @patient.id), notice: t(".success", model_name: "bookmark")
      end

      def destroy
        bookmark = patients_user.bookmarks.find(params[:id])
        authorize bookmark

        bookmark.destroy
        redirect_to patient_path(bookmark.patient_id),
          notice: t(".success", model_name: "bookmark")
      end

      private

      def patients_user
        @patients_user ||= Renalware::Patients.cast_user(current_user)
      end
    end
  end
end
