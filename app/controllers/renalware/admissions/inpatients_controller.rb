require "renalware/admissions"
require "collection_presenter"

module Renalware
  module Admissions
    class InpatientsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        query = InpatientQuery.new(params[:q])
        inpatients = query.call.page(page).per(per_page)
        authorize inpatients
        render locals: {
          inpatients:  CollectionPresenter.new(inpatients, InpatientPresenter),
          query: query.search
        }
      end

      def new
        inpatient = Inpatient.new(admitted_on: Time.zone.today)
        authorize inpatient
        render_new(inpatient)
      end

      def create
        inpatient = Inpatient.new(inpatient_params)
        authorize inpatient
        if inpatient.save_by(current_user)
          redirect_to admissions_inpatients_path, notice: success_msg_for("inpatient")
        else
          render_new(inpatient)
        end
      end

      def edit
        render_edit(find_and_authorize_inpatient)
      end

      def update
        inpatient = find_and_authorize_inpatient
        if inpatient.update_by(current_user, inpatient_params)
          redirect_to admissions_inpatients_path, notice: success_msg_for("inpatient")
        else
          render_edit(inpatient)
        end
      end

      def destroy
        find_and_authorize_inpatient.destroy!
        redirect_to admissions_inpatients_path, notice: success_msg_for("inpatient")
      end

      private

      def find_and_authorize_inpatient
        Inpatient.find(params[:id]).tap do |inpatient|
          authorize inpatient
        end
      end

      def render_new(inpatient)
        render :new, locals: { inpatient: inpatient }
      end

      def render_edit(inpatient)
        render :edit, locals: { inpatient: inpatient }
      end

      def inpatient_params
        params
          .require(:admissions_inpatient)
          .permit(
            :hospital_unit_id, :hospital_ward_id, :patient_id, :q,
            :admitted_on, :admission_type, :consultant, :modality,
            :reason_for_admission, :notes, :transferred_on, :transferred_to,
            :discharged_on, :discharge_destination, :destination_notes,
            :discharge_summary, :summarised_on, :summarised_by_id
          )
      end
    end
  end
end
