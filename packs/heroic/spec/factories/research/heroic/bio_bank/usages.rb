# frozen_string_literal: true

FactoryBot.define do
  factory :bio_bank_usage, class: "Renalware::Heroic::BioBank::Usage" do
    used_at { 1.day.ago }
    study_name { "Study1" }
  end
end
