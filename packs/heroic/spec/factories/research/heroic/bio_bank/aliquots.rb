# frozen_string_literal: true

FactoryBot.define do
  factory :bio_bank_aliquot, class: "Renalware::Heroic::BioBank::Aliquot" do
    trait :used do
      usage factory: %i(bio_bank_usage)
    end
  end
end
