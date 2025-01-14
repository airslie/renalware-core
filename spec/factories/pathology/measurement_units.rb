FactoryBot.define do
  sequence(:measurement_unit) { "10(#{it})/L" }
  factory :pathology_measurement_unit,
          class: "Renalware::Pathology::MeasurementUnit" do
    name { generate(:measurement_unit) }
    description { "" }
  end
end
