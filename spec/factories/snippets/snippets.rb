# frozen_string_literal: true

FactoryBot.define do
  factory :snippet, class: "Renalware::Snippeting::Snippet" do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
  end
end
