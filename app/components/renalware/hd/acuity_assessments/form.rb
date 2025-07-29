# frozen_string_literal: true

module Renalware
  class HD::AcuityAssessments::Form < Shared::Form
    def initialize(model, return_to: nil)
      attrs = { return_to:, class: "large-9 columns" }
      super(model, **attrs)
    end

    def view_template
      super do
        Lead(class: "text-lg font-bold text-gray-900") { "Select the HD acuity ratio" }
        ratio_radios
      end
    end

    def ratio_radios
      ErrorMessage(model, :ratio)
      input(type: "hidden", name: "hd_acuity_assessment[ratio]", value: "")
      ratios.each { |value, attrs| render_radio(value, attrs) }
    end

    private

    def render_radio(value, attrs)
      label, color = attrs.values_at(:label, :color)
      id = "ratio_#{value.to_f}"
      div(class: "flex items-center gap-2") do
        RadioButton(value:, id:, name: "hd_acuity_assessment[ratio]")
        label(for: id, class: "inline-block w-40") do
          Badge(label:, color:, class: "w-full")
        end
      end
    end

    def ratios
      HD::AcuityAssessments::Table::RATIOS
    end
  end
end
