require "renalware/admissions"
require "collection_presenter"

module Renalware
  module Admissions
    class ConsultsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        authorize Consult, :index?
        render locals: { consults: consults }
      end

      def new
        consult = Consult.new(started_on: Time.zone.today)
        authorize consult
        render_new(consult)
      end

      def create
        consult = Consult.new(consult_params)
        authorize consult
        if consult.save_by(current_user)
          redirect_to admissions_consults_path, notice: success_msg_for("consult")
        else
          render_new(consult)
        end
      end

      def edit
        render_edit(find_and_authorize_consult)
      end

      def update
        consult = find_and_authorize_consult
        if consult.update_by(current_user, consult_params)
          redirect_to admissions_consults_path, notice: success_msg_for("consult")
        else
          render_edit(consult)
        end
      end

      private

      def consults
        CollectionPresenter.new(
          Consult.all.order(created_at: :desc).page(page).per(per_page),
          ConsultPresenter
        )
      end

      def find_and_authorize_consult
        Consult.find(params[:id]).tap do |consult|
          authorize consult
        end
      end

      def render_new(consult)
        render :new, locals: { consult: consult }
      end

      def render_edit(consult)
        render :edit, locals: { consult: consult }
      end

      def consult_params
        params
          .require(:admissions_consult)
          .permit(
            :hospital_unit_id, :hospital_ward_id, :patient_id,
            :decided_on, :transferred_on, :started_on, :ended_on, :decided_on,
            :aki_risk, :transfer_priority, :seen_by, :consult_type,
            :requires_aki_nurse, :description
          )
      end
    end
  end
end
