# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_obx_mapping, class: "Renalware::Pathology::OBXMapping" do
    association :observation_description, factory: :pathology_observation_description, code: "HGB"
    association :sender
    code_alias { "HB" }
  end
end
