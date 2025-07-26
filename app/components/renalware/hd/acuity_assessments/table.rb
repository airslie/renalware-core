# frozen_string_literal: true

module Renalware
  class HD::AcuityAssessments::Table < Shared::Table
    register_output_helper :pagy_nav, mark_safe: true

    COLORS = {
      "1:4" => "bg-green-300",
      "1:3" => "bg-lime-900",
      "1:2" => "bg-orange-500",
      "1:1" => "bg-red-600"
    }.freeze

    def initialize(assessments:, pagy:, back_to:, current_user:)
      @assessments = assessments
      @pagy = pagy
      @back_to = back_to
      @current_user = current_user
      super()
    end

    def view_template
      super(class: "hd-acuity-assessments") do
        table_header
        TableBody do
          assessments.each { row(it) }
        end
      end
      pagy_nav(pagy) if pagy && pagy.pages > 1
    end

    private

    attr_reader :assessments, :pagy, :back_to, :current_user

    def row(assessment)
      TableRow do
        TableCell { DeleteIcon(path: assessment_path(assessment), policy: policy(assessment)) }
        TableCell { Badge(assessment.ratio, colors: COLORS, class: "text-center") }
        DateCell(assessment.created_at)
        TableCell { assessment.created_by.to_s }
      end
    end

    def table_header
      TableHeader do
        TableRow do
          TableHead(class: %w(noprint w-5))
          TableHead(class: %w(col-width-small)) { "Ratio" }
          DateHead()
          TableHead { "Assessor" }
        end
      end
    end

    def assessment_path(assessment)
      patient_hd_acuity_assessment_path(assessment.patient, assessment, redirect_to: back_to)
    end

    def policy(assessment)
      Renalware::HD::AcuityAssessmentPolicy.new(current_user, assessment)
    end
  end
end
