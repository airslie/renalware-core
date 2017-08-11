module Renalware
  module Accesses
    class AssessmentsController < Accesses::BaseController
      before_action :load_patient

      def show
        assessment = patient.assessments.find(params[:id])
        render locals: {
          patient: patient,
          assessment: AssessmentPresenter.new(assessment)
        }
      end

      def new
        assessment = AssessmentFactory.new(patient: patient).build
        render_new(assessment)
      end

      def create
        assessment = patient.assessments.new(assessment_params)

        if assessment.save
          redirect_to patient_accesses_dashboard_path(patient),
            notice: t(".success", model_name: "Access assessment")
        else
          flash.now[:error] = t(".failed", model_name: "Access assessment")
          render_new(assessment)
        end
      end

      def edit
        assessment = patient.assessments.find(params[:id])
        render_edit(assessment)
      end

      def update
        assessment = patient.assessments.find(params[:id])

        if assessment.update(assessment_params)
          redirect_to patient_accesses_dashboard_path(patient),
            notice: t(".success", model_name: "Access assessment")
        else
          flash.now[:error] = t(".failed", model_name: "Access assessment")
          render_edit(assessment)
        end
      end

      protected

      def render_new(assessment)
        render :new, locals: { patient: patient, assessment: assessment }
      end

      def render_edit(assessment)
        render :edit, locals: { patient: patient, assessment: assessment }
      end

      def assessment_params
        params
          .require(:accesses_assessment)
          .permit(attributes)
          .merge(document: document_attributes, by: current_user)
      end

      def attributes
        [
          :performed_on, :first_used_on, :failed_on,
          :side, :type_id,
          :catheter_make, :catheter_lot_no,
          :performed_by, :notes, :outcome,
          document: []
        ]
      end

      def document_attributes
        params
          .require(:accesses_assessment)
          .fetch(:document, nil).try(:permit!)
      end
    end
  end
end
