module Renalware
  module Accesses
    class PlansController < Accesses::BaseController
      def new
        plan = Plan.new
        authorize plan
        render_new(plan)
      end

      def create
        plan = patient.plans.new(plan_params.merge!(by: current_user))
        authorize plan
        if save_as_current(plan)
          redirect_to patient_accesses_dashboard_path(patient)
        else
          render_new(plan)
        end
      end

      def show
        plan = Plan.find(params[:id])
        authorize plan
        render locals: { patient: patient, plan: plan }
      end

      private

      def save_as_current(plan)
        Plan.transaction do
          if current_plan.present?
            current_plan.terminated_at = Time.zone.now
            current_plan.by = current_user
            current_plan.save!
          end
          plan.save!
        end
      rescue ActiveRecord::RecordInvalid
        false
      end

      def render_new(plan)
        render :new, locals: { patient: patient, plan: plan }
      end

      def plan_params
        params.require(:accesses_plan).permit(:plan_type_id, :notes, :decided_by_id)
      end

      def current_plan
        @current_plan ||= patient.plans.current.first
      end
    end
  end
end
