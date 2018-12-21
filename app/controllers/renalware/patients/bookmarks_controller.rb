# frozen_string_literal: true

module Renalware
  module Patients
    class BookmarksController < BaseController
      include Concerns::Pageable
      before_action :load_patient, only: :create

      # Display the user's bookmarks
      def index
        search = Patients.cast_user(current_user)
          .bookmarks
          .ordered
          .includes(patient: [current_modality: :description])
          .ransack(search_params)

        bookmarks = search.result.page(page).per(per_page)
        authorize bookmarks
        render locals: { bookmarks: bookmarks, search: search }
      end

      # idempotent
      def create
        Bookmark.find_or_create_by!(user: user, patient: patient) do |bookmark|
          bookmark.assign_attributes(bookmark_params)
        end
        redirect_back(fallback_location: patient_path(patient),
                      notice: success_msg_for("bookmark"))
      end

      # idempotent
      # rubocop:disable Metrics/AbcSize
      def destroy
        bookmark = user.bookmarks.find_by(id: params[:id])
        patient = bookmark&.patient
        if bookmark.present?
          authorize bookmark
          bookmark.destroy
        else
          skip_authorization
        end
        fallback_location = patient.presence || root_path
        redirect_back(fallback_location: patient_path(fallback_location),
                      notice: success_msg_for("bookmark"))
      end
      # rubocop:enable Metrics/AbcSize

      private

      def user
        @user ||= Renalware::Patients.cast_user(current_user)
      end

      def bookmark_params
        params.require(:patients_bookmark).permit(:notes, :urgent, :tags)
      end

      def search_params
        hash = params[:q] || {}
        hash[:s] ||= "created_at desc"
        hash
      end
    end
  end
end
