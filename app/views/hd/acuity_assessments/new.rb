# frozen_string_literal: true

class Views::HD::AcuityAssessments::New < Views::Base
  register_output_helper :within_patient_layout
  register_value_helper :hd_summary_breadcrumb

  def initialize(assessment:, return_to: nil)
    @assessment = assessment
    @return_to = return_to || patient_hd_dashboard_path(assessment.patient)
    super()
  end

  def view_template
    within_patient_layout(
      title: "New HD Acuity Assessment",
      breadcrumbs: [hd_summary_breadcrumb(assessment.patient)]
    ) do
      render Renalware::HD::AcuityAssessments::Form.new(assessment, return_to:)
    end
  end

  private

  attr_reader :assessment, :return_to
end
