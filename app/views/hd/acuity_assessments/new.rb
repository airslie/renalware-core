# frozen_string_literal: true

class Views::HD::AcuityAssessments::New < Views::Base
  register_output_helper :within_patient_layout
  register_value_helper :hd_summary_breadcrumb

  def initialize(assessment:, referer: nil)
    @assessment = assessment
    @referer = referer || patient_hd_dashboard_path(assessment.patient)
    super()
  end

  def view_template
    within_patient_layout(
      title: "New HD Acuity Assessment",
      breadcrumbs: [hd_summary_breadcrumb(assessment.patient)]
    ) do
      render Renalware::HD::AcuityAssessments::Form.new(assessment, back_to: referer)
    end
  end

  private

  attr_reader :assessment, :referer
end
