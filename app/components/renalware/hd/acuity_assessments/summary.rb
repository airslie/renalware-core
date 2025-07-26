# frozen_string_literal: true

class Renalware::HD::AcuityAssessments::Summary < Shared::Base
  def initialize(assessments:, current_user:, patient:, pagy: nil, back_to: nil)
    @assessments = assessments
    @current_user = current_user
    @patient = patient
    @pagy = pagy
    @back_to = back_to
    super()
  end

  def render? = back_to != dashboard_path || assessments.any?

  def view_template
    article(class: "acuity-assessments") do
      render_header
      render Renalware::HD::AcuityAssessments::Table.new(
        assessments:,
        pagy:,
        back_to:,
        current_user:
      )
    end
  end

  def render_header
    header do
      h2 do
        a(href: list_path) { "Acuity Assessments" }
      end
      ul(class: "flex justify-end") do
        li { pdf_button }
        li { add_button }
      end
    end
  end

  def pdf_button
    span do
      a(href: pdf_path, class: "button secondary", target: "_blank") do
        div(class: "flex mr-2") do
          div(class: "mt-px mr-2") { Icon(:pdf) }
          render "Guide"
        end
      end
    end
  end

  def add_button
    span do
      a(href: add_path, class: "button") do
        render "Add"
      end
    end
  end

  private

  attr_reader :assessments, :current_user, :patient, :pagy

  def pdf_path = asset_path("renalware/hd_acuity_score_guide.pdf")
  def add_path = new_patient_hd_acuity_assessment_path(patient)
  def list_path = patient_hd_acuity_assessments_path(patient)
  def back_to = @back_to || dashboard_path
  def dashboard_path = patient_hd_dashboard_path(patient)
end
