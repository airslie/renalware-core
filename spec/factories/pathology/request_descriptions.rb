# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_request_description, class: "Renalware::Pathology::RequestDescription" do
    association :lab, factory: :pathology_lab
    code "FBC"
  end
end
