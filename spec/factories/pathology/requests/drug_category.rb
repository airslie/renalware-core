# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_requests_drug_category,
          class: "Renalware::Pathology::Requests::DrugCategory" do
    name { "Ciclosporin" }
  end
end
