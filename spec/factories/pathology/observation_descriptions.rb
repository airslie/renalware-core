FactoryGirl.define do
  factory :pathology_observation_description,
      class: "Renalware::Pathology::ObservationDescription" do
    code "WBR"
    association :measurement_unit, factory: :pathology_measurement_unit
  end
end
