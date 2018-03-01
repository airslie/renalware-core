# frozen_string_literal: true

FactoryBot.define do
  factory :event_type, class: "Renalware::Events::Type" do
    initialize_with { Renalware::Events::Type.find_or_create_by(name: name) }

    factory :access_clinic_event_type do
      name "Access--Clinic"
    end

    factory :swab_event_type do
      name "Swab"
      event_class_name "Renalware::Events::Swab"
      slug "swabs"
    end

    factory :biopsy_event_type do
      name "Renal biopsy"
      event_class_name "Renalware::Events::Biopsy"
    end

    factory :pd_line_change_event_type do
      name "PD Line Change"
      slug "pd_line_changes"
    end

    factory :investigation_event_type do
      name "Investigation"
      slug "investigations"
      event_class_name "Renalware::Events::Investigation"
    end

    factory :vaccination_event_type do
      name "Vaccination"
      slug "vaccinations"
      event_class_name "Renalware::Virology::Vaccination"
    end
  end
end
