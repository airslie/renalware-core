# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_observation_description,
          class: "Renalware::Pathology::ObservationDescription" do
    initialize_with do
      Renalware::Pathology::ObservationDescription.find_or_create_by!(code: code)
    end

    before(:create){ |desc| desc.loinc_code ||= desc.code.downcase }

    code "WBR"
    association :measurement_unit, factory: :pathology_measurement_unit
    display_group 1
    display_order 1
    letter_group 1
    letter_order 1
  end
end
