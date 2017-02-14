module Renalware
  module PatientHelper
    def formatted_nhs_number(patient)
      PatientPresenter.new(patient).nhs_number
    end

    def patient_page_title(title:, patient:, separator: " – ")
      patient_details = "#{patient} #{patient.age}y #{patient.sex}"
      page_title = [patient_details, title].join(separator)
      content_for(:page_title){ page_title }
    end

    def within_patient_layout(title: nil, **opts)
      title ||= t?(".page_title") ? t(".page_title") : t(".title", cascade: false)
      opts[:title] = title
      render layout: "renalware/patients/layout", locals: opts do
        yield
      end
    end

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
  end
end
