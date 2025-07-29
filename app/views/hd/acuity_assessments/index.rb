# frozen_string_literal: true

# 2025-07-29
# This is an example of how we might use Phlex to render a view.
# It's not yet decideded if we'll use Phlex for View rendering.
# So check whether this is still relevant.

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
        pagy:
      )
    end
  end

  private

  attr_reader :assessments, :patient, :current_user, :pagy
end
