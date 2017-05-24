require_dependency "renalware/pd"

module Renalware
  module PD
    class AssessmentsController < BaseController

      def new
        assessment = PD::Assessment.for_patient(patient).new
        authorize assessment
        render locals: { patient: patient, assessment: assessment }
      end

      def create
        assessment = PD::Assessment.for_patient(patient).new
        authorize assessment
        if assessment.update(assessment_params)
          redirect_to patient_pd_dashboard_path(patient),
                      notice: success_msg_for("assessment")
        else
          render :new, locals: { patient: patient, assessment: assessment }
        end
      end

      private

      def assessment_params
        params
          .require(:assessment)
          .permit(attributes)
          .merge(document: document_attributes, by: current_user)
      end

      def attributes
        [
          document: []
        ]
      end

      def document_attributes
        params.require(:assessment).fetch(:document, nil).try(:permit!)
      end
    end
  end
end
