# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_obx_mapping, class: "Renalware::Pathology::OBXMapping" do
    observation_description factory: %i(pathology_observation_description), code: "HGB"
    sender
    code_alias { "HB" }
  end
end
