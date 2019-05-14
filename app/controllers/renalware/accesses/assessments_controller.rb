# frozen_string_literal: true

module Renalware
  module Accesses
    class AssessmentsController < Accesses::BaseController
      before_action :load_patient

      def show
        render locals: {
          patient: patient,
          assessment: AssessmentPresenter.new(find_assessement)
        }
      end

      def new
        assessment = AssessmentFactory.new(patient: patient).build
        render_new(assessment)
      end

      def create
        assessment = patient.assessments.new(assessment_params)

        if assessment.save_by(current_user)
          redirect_to patient_accesses_dashboard_path(patient),
                      notice: t(".success", model_name: "Access assessment")
        else
          flash.now[:error] = t(".failed", model_name: "Access assessment")
          render_new(assessment)
        end
      end

      def edit
        render_edit(find_assessement)
      end

      def update
        assessment = find_assessement

        if assessment.update_by(current_user, assessment_params)
          redirect_to patient_accesses_dashboard_path(patient),
                      notice: t(".success", model_name: "Access assessment")
        else
          flash.now[:error] = t(".failed", model_name: "Access assessment")
          render_edit(assessment)
        end
      end

      protected

      def find_assessement
        patient.assessments.find(params[:id])
      end

      def render_new(assessment)
        render :new, locals: { patient: patient, assessment: assessment }
      end

      def render_edit(assessment)
        render :edit, locals: { patient: patient, assessment: assessment }
      end

      def assessment_params
        params.require(:accesses_assessment).permit(attributes)
      end

      def attributes
        [
          :performed_on, :first_used_on, :failed_on,
          :side, :type_id,
          :catheter_make, :catheter_lot_no,
          :performed_by, :notes, :outcome, :comments,
          document: {}
        ]
      end
    end
  end
end
