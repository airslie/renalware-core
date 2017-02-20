module Renalware
  module PatientHelper
    def patient_menu_item(title:, path:, active_when_controller_matches:, enabled: true)
      klasses = %w(link)
      klasses << "active" if current_controller_matches(active_when_controller_matches)
      content_tag :li, class: klasses.join(" ") do
        link_to_if(enabled, title, path)
      end
    end

    def current_controller_matches(regex)
      regex.match(params[:controller]).present?
    end

    def formatted_nhs_number(patient)
      PatientPresenter.new(patient).nhs_number
    end
  end
end
