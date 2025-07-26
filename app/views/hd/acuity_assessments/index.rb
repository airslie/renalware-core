# frozen_string_literal: true

class Views::HD::AcuityAssessments::Index < Views::Base
  register_output_helper :within_patient_layout
  register_value_helper :hd_summary_breadcrumb

  def initialize(assessments:, patient:, current_user:, pagy: nil)
    @assessments = assessments
    @current_user = current_user
    @patient = patient
    @pagy = pagy
    super()
  end

  def view_template
    within_patient_layout(
      title: "HD Acuity Assessments",
      breadcrumbs: [hd_summary_breadcrumb(patient)]
    ) do
      render Renalware::HD::AcuityAssessments::Summary.new(
        assessments:,
        patient:,
        current_user:,
        pagy:,
        back_to:
      )
    end
  end

  private

  attr_reader :assessments, :patient, :current_user, :pagy

  def back_to = patient_hd_acuity_assessments_path(patient)
end
