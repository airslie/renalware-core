# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_lab, class: "Renalware::Pathology::Lab" do
    name { %w(Biochemistry Microbiology Haemotology Virology).sample }

    trait :uknown do
      name { Renalware::Pathology::Lab::UNKNOWN_LAB_NAME }
    end
  end
end
