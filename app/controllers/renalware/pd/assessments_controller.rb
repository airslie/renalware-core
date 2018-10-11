# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class AssessmentsController < BaseController
      def show
        assessment = find_assessment
        authorize assessment
        render locals: { patient: patient, assessment: assessment }
      end

      def new
        assessment = PD::Assessment.for_patient(patient).new
        authorize assessment
        render locals: { patient: patient, assessment: assessment }
      end

      def create
        assessment = PD::Assessment.for_patient(patient).new(assessment_params)
        authorize assessment
        if assessment.save_by(current_user)
          redirect_to patient_pd_dashboard_path(patient),
                      notice: success_msg_for("assessment")
        else
          render :new, locals: { patient: patient, assessment: assessment }
        end
      end

      def edit
        assessment = find_assessment
        authorize assessment
        render locals: { patient: patient, assessment: assessment }
      end

      def update
        assessment = find_assessment
        authorize assessment
        if assessment.update_by(current_user, assessment_params)
          redirect_to patient_pd_dashboard_path(patient),
                      notice: success_msg_for("assessment")
        else
          render :edit, locals: { patient: patient, assessment: assessment }
        end
      end

      private

      def find_assessment
        PD::Assessment.for_patient(patient).find(params[:id])
      end

      def assessment_params
        params.require(:assessment).permit(document: {})
      end
    end
  end
end
