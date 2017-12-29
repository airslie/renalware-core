require "renalware/admissions"
require "collection_presenter"

module Renalware
  module Admissions
    class AdmissionsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        admissions = search_form.submit.page(page).per(per_page)
        authorize admissions

        render locals: {
          admissions: CollectionPresenter.new(admissions, AdmissionPresenter),
          form: search_form
        }
      end

      def new
        admission = Admission.new(admitted_on: Time.zone.today)
        authorize admission
        render_new(admission)
      end

      def create
        admission = Admission.new(admission_params)
        authorize admission
        if admission.save_by(current_user)
          redirect_to admissions_admissions_path, notice: success_msg_for("admission")
        else
          render_new(admission)
        end
      end

      def edit
        render_edit(find_and_authorize_admission)
      end

      def update
        admission = find_and_authorize_admission
        if admission.update_by(current_user, admission_params)
          redirect_to admissions_admissions_path, notice: success_msg_for("admission")
        else
          render_edit(admission)
        end
      end

      def destroy
        find_and_authorize_admission.destroy!
        redirect_to admissions_admissions_path, notice: success_msg_for("admission")
      end

      private

      def search_form
        @search_form ||= begin
          options = params.key?(:query) ? search_params : {}
          AdmissionSearchForm.new(options)
        end
      end

      def find_and_authorize_admission
        Admission.find(params[:id]).tap do |admission|
          authorize admission
        end
      end

      def render_new(admission)
        render :new, locals: { admission: admission }
      end

      def render_edit(admission)
        render :edit, locals: { admission: admission }
      end

      def search_params
        params
          .require(:query) {}
          .permit(:hospital_unit_id, :hospital_ward_id, :status, :term)
      end

      def admission_params
        params
          .require(:admissions_admission)
          .permit(
            :hospital_ward_id, :patient_id, :q,
            :admitted_on, :admission_type, :consultant, :modality,
            :reason_for_admission, :notes, :transferred_on, :transferred_to,
            :discharged_on, :discharge_destination, :destination_notes,
            :discharge_summary, :summarised_on, :summarised_by_id
          )
      end
    end
  end
end
