# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_request_description, class: "Renalware::Pathology::RequestDescription" do
    initialize_with { Renalware::Pathology::RequestDescription.find_or_create_by(code: code) }
    association :lab, factory: :pathology_lab
    code "FBC"
  end
end
