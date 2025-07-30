# frozen_string_literal: true

class Renalware::HD::AcuityAssessments::PdfLink < Shared::Base
  def view_template
    span do
      a(href: pdf_path, class: "button secondary", target: "_blank") do
        div(class: "flex mr-2") do
          div(class: "mt-px mr-2") { Icon(:pdf) }
          render "Guide"
        end
      end
    end
  end

  private

  def pdf_path = asset_path("renalware/hd_acuity_score_guide.pdf")
end
