# frozen_string_literal: true

require "collection_presenter"

module Renalware
  module Accesses
    class NeedlingAssessmentsController < Accesses::BaseController
      def new
        difficulty = patient.needling_assessments.new
        authorize difficulty
        render locals: { difficulty: difficulty }
      end

      def create
        difficulty = patient.needling_assessments.new(needling_assessment_params)
        authorize difficulty
        if difficulty.save_by(current_user)
          redirect_to patient_accesses_dashboard_path(patient)
        else
          render :new, locals: { difficulty: difficulty }
        end
      end

      def destroy
        assessment = patient.needling_assessments.find(params[:id])
        authorize assessment
        assessment.destroy!
        redirect_back(
          fallback_location: patient_accesses_dashboard_path(patient),
          notice: success_msg_for("needling assessment")
        )
      end

      private

      def needling_assessment_params
        params
          .require(:needling_assessment)
          .permit(:difficulty)
      end
    end
  end
end
