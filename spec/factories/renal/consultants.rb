# frozen_string_literal: true

FactoryBot.define do
  factory :renal_consultant, class: "Renalware::Renal::Consultant" do
    initialize_with { Renalware::Renal::Consultant.find_or_create_by(name: name) }
    name { "name" }
    code { "code" }
  end
end
