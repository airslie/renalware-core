FactoryBot.define do
  factory :drug_unit_of_measure, class: "Renalware::Drugs::UnitOfMeasure" do
    sequence(:code) { "Code#{it}" }
  end
end
