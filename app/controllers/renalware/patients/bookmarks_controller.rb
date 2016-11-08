module Renalware
  module Patients
    class BookmarksController < BaseController
      before_action :load_patient, only: :create

      def create
        patients_user.bookmarks.create!(bookmark_params.update(patient: patient))
        redirect_to :back, notice: t(".success", model_name: "bookmark")
      end

      def destroy
        bookmark = patients_user.bookmarks.find(params[:id])
        authorize bookmark

        bookmark.destroy
        redirect_to :back, notice: t(".success", model_name: "bookmark")
      end

      private

      def patients_user
        @patients_user ||= Renalware::Patients.cast_user(current_user)
      end

      def bookmark_params
        params.require(:patients_bookmark).permit(:notes, :urgent)
      end
    end
  end
end
