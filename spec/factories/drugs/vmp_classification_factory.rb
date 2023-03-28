# frozen_string_literal: true

FactoryBot.define do
  factory :drug_vmp_classification,
          class: "Renalware::Drugs::VMPClassification" do
    sequence :code do |n| "VMP-CODE-#{n}" end
    drug { nil }
    form { nil }
    route { nil }
    unit_of_measure { nil }
  end
end
