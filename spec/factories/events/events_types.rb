# frozen_string_literal: true

FactoryBot.define do
  factory :event_type, class: "Renalware::Events::Type" do
    initialize_with { Renalware::Events::Type.find_or_create_by(name: name) }

    factory :access_clinic_event_type do
      name { "Access--Clinic" }
      hidden { false }
    end

    factory :swab_event_type do
      name { "Swab" }
      event_class_name { "Renalware::Events::Swab" }
      slug { "swabs" }
    end

    factory :biopsy_event_type do
      name { "Renal biopsy" }
      event_class_name { "Renalware::Events::Biopsy" }
    end

    factory :pd_line_change_event_type do
      name { "PD Line Change" }
      slug { "pd_line_changes" }
    end

    factory :investigation_event_type do
      name { "Investigation" }
      slug { "investigations" }
      event_class_name { "Renalware::Events::Investigation" }
    end

    factory :vaccination_event_type do
      name { "Vaccination" }
      slug { "vaccinations" }
      event_class_name { "Renalware::Virology::Vaccination" }
    end

    factory :advanced_care_plan do
      name { "AdvancedCarePlan" }
      slug { "advanced_care_plans" }
      event_class_name { "Renalware::Events::AdvancedCarePlan" }
    end

    factory :clinical_frailty_score do
      name { "Clinical Frailty Score" }
      slug { "clinical_frailty_scores" }
      event_class_name { "Renalware::Clinical::FrailtyScore" }
    end
  end
end
