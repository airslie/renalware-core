# frozen_string_literal: true

FactoryBot.define do
  factory :bio_bank_aliquot, class: "Renalware::Heroic::BioBank::Aliquot" do
    trait :used do
      association :usage, factory: :bio_bank_usage
    end
  end
end
