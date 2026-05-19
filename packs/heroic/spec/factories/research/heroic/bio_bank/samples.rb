# frozen_string_literal: true

FactoryBot.define do
  factory :bio_bank_sample, class: "Renalware::Heroic::BioBank::Sample" do
    patient
    received_at { Time.zone.now }
    processed_at { Time.zone.now }
    storage_location { "PlaceA" }

    trait :dna do
      sample_type factory: %i(dna_sample_type)
    end

    trait :rna do
      sample_type factory: %i(rna_sample_type)
    end

    trait :serum do
      sample_type factory: %i(serum_sample_type)
    end

    trait :epla do
      sample_type factory: %i(epla_sample_type)
    end

    trait :urine do
      sample_type factory: %i(urine_sample_type)
    end

    trait :urine_with_inhibitor do
      sample_type factory: %i(urine_with_inhibitor_sample_type)
    end
  end
end
