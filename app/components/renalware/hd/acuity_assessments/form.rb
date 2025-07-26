# frozen_string_literal: true

module Renalware
  class HD::AcuityAssessments::Form < Shared::Form
    def initialize(model, back_to: nil)
      attrs = { back_to:, class: "large-9 columns" }
      super(model, **attrs)
    end

    def view_template
      super do
        Lead(class: "text-lg font-bold text-gray-900") { "Select the HD acuity ratio" }
        ratio_radios
      end
    end

    # TODO: Factor this out into a shared component
    def ratio_radios
      ErrorMessage(model, :ratio)
      input(type: "hidden", name: "hd_acuity_assessment[ratio]", value: "")
      model.class.ratios.each_key do |ratio|
        div(class: "flex items-center gap-2") do
          RadioButton(value: ratio, id: "ratio_#{ratio}", name: "hd_acuity_assessment[ratio]")
          label(for: "ratio_#{ratio}", class: "inline-block w-40") do
            Badge(ratio, colors: HD::AcuityAssessments::Table::COLORS, class: "w-full")
          end
        end
      end
    end
  end
end
