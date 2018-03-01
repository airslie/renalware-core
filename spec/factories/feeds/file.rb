# frozen_string_literal: true

FactoryBot.define do
  factory :feed_file, class: "Renalware::Feeds::File" do
    association :file_type, factory: :feed_file_type
    accountable

    trait :practices do
      association :file_type, factory: [:feed_file_type, :practices]
    end

    trait :primary_care_physicians do
      association :file_type, factory: [:feed_file_type, :primary_care_physicians]
    end
  end
end
