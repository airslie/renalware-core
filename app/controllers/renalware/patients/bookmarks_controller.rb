module Renalware
  module Patients
    class BookmarksController < BaseController
      before_action :load_patient

      def create
        user = Renalware::Patients.cast_user(current_user)
        user.bookmarks.create!(patient: @patient)

        redirect_to patient_path(id: @patient.id), notice: t(".success", model_name: "bookmark")
      end
    end
  end
end
