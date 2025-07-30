# frozen_string_literal: true

class Renalware::HD::AcuityAssessments::Summary < Shared::Base
  include Phlex::Rails::Helpers::CurrentPage

  def initialize(assessments:, current_user:, patient:, pagy: nil)
    @assessments = assessments
    @current_user = current_user
    @patient = patient
    @pagy = pagy
    super()
  end

  def render?
    return true if current_page?(list_path)

    assessments.any?
  end

  def view_template
    article(class: "acuity-assessments") do
      render_header
      render Renalware::HD::AcuityAssessments::Table.new(
        assessments:,
        pagy:,
        current_user:
      )
    end
  end

  def render_header
    header do
      h2 { a(href: list_path) { "Acuity Assessments" } } unless current_page?(list_path)
      ul(class: "flex justify-end") do
        li { render Renalware::HD::AcuityAssessments::PdfLink }
        li { add_link }
      end
    end
  end

  def add_link
    span do
      a(href: add_path, class: "button") do
        render "Add"
      end
    end
  end

  private

  attr_reader :assessments, :current_user, :patient, :pagy

  def add_path = new_patient_hd_acuity_assessment_path(patient)
  def list_path = patient_hd_acuity_assessments_path(patient)
  def dashboard_path = patient_hd_dashboard_path(patient)
end
