module Renalware
  module HD
    class AcuityAssessmentsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Pagy::Backend

      def index
        pagy, assessments = pagy AcuityAssessment.for_patient(hd_patient).ordered
        authorize assessments
        render Views::HD::AcuityAssessments::Index.new(
          assessments:,
          patient:,
          current_user:,
          pagy:
        )
      end

      def new
        assessment = hd_patient.acuity_assessments.new
        authorize assessment
        render_new(assessment)
      end

      def create
        assessment = hd_patient.acuity_assessments.new(assessment_params)
        authorize assessment
        if assessment.save_by(current_user)
          redirect_to back_to || renalware.patient_hd_acuity_assessments_path(patient),
                      notice: success_msg_for("Acuity assessment")
        else
          render_new(assessment)
        end
      end

      def destroy
        assessment = find_assessment
        authorize assessment
        assessment.destroy!
        redirect_to params[:redirect_to], notice: success_msg_for("HD Acuity Assessment")
      end

      private

      def find_assessment
        AcuityAssessment.for_patient(hd_patient).find(params[:id])
      end

      def render_new(assessment)
        render Views::HD::AcuityAssessments::New.new(
          assessment:,
          referer: request.referer
        )
      end

      def assessment_params
        params
          .require(:hd_acuity_assessment)
          .permit(:ratio)
          .merge(by: current_user)
      end

      def back_to = params[:back_to]
    end
  end
end
