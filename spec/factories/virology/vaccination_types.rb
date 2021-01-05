# frozen_string_literal: true

FactoryBot.define do
  factory :vaccination_type, class: "Renalware::Virology::VaccinationType" do
    code { "code" }
    name { "name" }
  end
end
