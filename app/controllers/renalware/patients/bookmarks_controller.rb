module Renalware
  module Patients
    class BookmarksController < BaseController
      before_action :load_patient, only: :create

      # idempotent
      def create
        Bookmark.find_or_create_by!(user: user, patient: patient) do |bookmark|
          bookmark.assign_attributes(bookmark_params)
        end
        redirect_to :back, notice: t(".success", model_name: "bookmark")
      end

      # idempotent
      def destroy
        bookmark = user.bookmarks.find_by(id: params[:id])
        if bookmark.present?
          authorize bookmark
          bookmark.destroy
        else
          skip_authorization
        end
        redirect_to :back, notice: t(".success", model_name: "bookmark")
      end

      private

      def user
        @user ||= Renalware::Patients.cast_user(current_user)
      end

      def bookmark_params
        params.require(:patients_bookmark).permit(:notes, :urgent)
      end
    end
  end
end
