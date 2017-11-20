module Renalware
  module Patients
    class BookmarksController < BaseController
      before_action :load_patient, only: :create

      # idempotent
      def create
        Bookmark.find_or_create_by!(user: user, patient: patient) do |bookmark|
          bookmark.assign_attributes(bookmark_params)
        end
        redirect_back(fallback_location: patient_path(patient),
                      notice: success_msg_for("bookmark"))
      end

      # idempotent
      def destroy
        bookmark = user.bookmarks.find_by(id: params[:id])
        patient = bookmark&.patient
        if bookmark.present?
          authorize bookmark
          bookmark.destroy
        else
          skip_authorization
        end
        fallback_location = patient.present? ? patient : root_path
        redirect_back(fallback_location: patient_path(fallback_location),
                      notice: success_msg_for("bookmark"))
      end

      private

      def user
        @user ||= Renalware::Patients.cast_user(current_user)
      end

      def bookmark_params
        params.require(:patients_bookmark).permit(:notes, :urgent, :tags)
      end
    end
  end
end
