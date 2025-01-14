FactoryBot.define do
  factory :drug_vmp_classification,
          class: "Renalware::Drugs::VMPClassification" do
    sequence(:code) { "VMP-CODE-#{it}" }
    drug { nil }
    form { nil }
    route { nil }
    unit_of_measure { nil }
  end
end
