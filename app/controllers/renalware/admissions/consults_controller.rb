require "renalware/admissions"

module Renalware
  module Admissions
    class ConsultsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        consults = Consult.all
        authorize consults
        render locals: { consults: consults }
      end

      def new
        consult = Consult.new
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

      # Don't update the participant id here (the patient) as that is immutable at this point.
      def update
        consult = find_and_authorize_consult
        if consult.update_by(current_user, consult_params)
          redirect_to admissions_consults_path, notice: success_msg_for("consult")
        else
          render_edit(consult)
        end
      end

      private

      def find_and_authorize_consult
        Consult.find(params[:id]).tap do |consult|
          authorize consult
        end
      end

      def render_new(consult)
        render :new, locals: { consult: consult }, layout: false
      end

      def render_edit(consult)
        render :edit, locals: { consult: consult }, layout: false
      end

      def consult_params
        params
          .require(:admissions_consult)
          .permit(:hospital_unit_id, :patient_id)
      end
    end
  end
end
