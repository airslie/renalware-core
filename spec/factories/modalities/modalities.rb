# frozen_string_literal: true

FactoryBot.define do
  factory :modality, class: "Renalware::Modalities::Modality" do
    accountable
    patient
    description factory: %i(modality_description)
    started_on { Date.parse("2015-04-01") }
    trait :terminated do
      state { "terminated" }
    end
    trait :pd_to_haemo
    trait :haemo_to_pd_modality
  end
end
