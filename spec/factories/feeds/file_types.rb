# frozen_string_literal: true

FactoryBot.define do
  factory :feed_file_type, class: "Renalware::Feeds::FileType" do
    name "Practices"
    description "Import practices"
    prompt "Where to get the file etc"

    trait :practices do
      name "Practices"
      description "Import practices"
    end

    trait :primary_care_physicians do
      name "GPs"
      description "Import GPs"
    end
  end
end
