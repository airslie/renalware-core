# frozen_string_literal: true

FactoryBot.define do
  factory :bio_bank_sample_type, class: "Renalware::Heroic::BioBank::SampleType" do
    initialize_with do
      Renalware::Heroic::BioBank::SampleType.find_or_create_by(
        name: name,
        abbreviation: abbreviation
      )
    end

    name { "DNA" }
    abbreviation { "WP-DNA" }

    factory :dna_sample_type do
      name { "DNA" }
      abbreviation { "WP-DNA" }
    end

    factory :rna_sample_type do
      name { "RNA" }
      abbreviation { "WP-RNA" }
    end

    factory :serum_sample_type do
      name { "Serum" }
      abbreviation { "SER" }
    end

    factory :epla_sample_type do
      name { "E-PLA" }
      abbreviation { "E-PLA" }
    end

    factory :urine_sample_type do
      name { "Urine-PL" }
      abbreviation { "Urine-PL" }
    end

    factory :urine_with_inhibitor_sample_type do
      name { "Urine-IN" }
      abbreviation { "Urine-IN" }
    end
  end
end
