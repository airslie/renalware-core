# frozen_string_literal: true

FactoryBot.define do
  factory :bio_bank_sample, class: "Renalware::Heroic::BioBank::Sample" do
    patient
    received_at { Time.zone.now }
    processed_at { Time.zone.now }
    storage_location { "PlaceA" }

    trait :dna do
      association :sample_type, factory: :dna_sample_type
    end

    trait :rna do
      association :sample_type, factory: :rna_sample_type
    end

    trait :serum do
      association :sample_type, factory: :serum_sample_type
    end

    trait :epla do
      association :sample_type, factory: :epla_sample_type
    end

    trait :urine do
      association :sample_type, factory: :urine_sample_type
    end

    trait :urine_with_inhibitor do
      association :sample_type, factory: :urine_with_inhibitor_sample_type
    end
  end
end
