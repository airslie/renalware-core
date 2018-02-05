FactoryBot.define do
  factory :pathology_observation_description,
          class: "Renalware::Pathology::ObservationDescription" do
    initialize_with do
      Renalware::Pathology::ObservationDescription.find_or_create_by!(code: code)
    end

    before(:create){ |desc| desc.loinc_code ||= desc.code.downcase }

    code "WBR"
    association :measurement_unit, factory: :pathology_measurement_unit
  end
end
