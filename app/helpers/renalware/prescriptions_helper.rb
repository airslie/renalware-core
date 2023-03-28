# frozen_string_literal: true

module Renalware
  module PrescriptionsHelper
    def highlight_validation_fail(med_object, med_attribute)
      return unless med_object.errors.include?(med_attribute)

      "field_with_errors"
    end

    def validation_fail(prescription)
      prescription.errors.any? ? "show-form" : "content"
    end

    def default_provider(provider)
      provider == "gp" ? "checked" : nil
    end

    def medication_and_route(med_route)
      if med_route.blank?
        "No medication prescribed"
      else
        other_route = "Route: Other (Please specify in notes)"
        safe_join(
          med_route.map do |m|
            route = if m.medication_route.name == other_route
                      m.medication_route.full_name
                    else
                      m.medication_route.name
                    end
            "<li>
                #{m.drug.name} - #{route}
            </li>".html_safe
          end
        )
      end
    end
  end
end
