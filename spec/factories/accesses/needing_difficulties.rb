# frozen_string_literal: true

FactoryBot.define do
  factory :access_needling_difficulty, class: "Renalware::Accesses::NeedlingDifficulty" do
    accountable
    association :patient, factory: :accesses_patient
    difficulty { "moderate" }
  end
end
