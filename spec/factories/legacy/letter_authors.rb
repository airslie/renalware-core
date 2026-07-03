# frozen_string_literal: true

FactoryBot.define do
  factory :legacy_letter_author, class: "Renalware::Legacy::LetterAuthor" do
    sequence(:name) { |n| "Legacy Author #{n}" }
    sequence(:code) { |n| "LA#{n}" }
  end
end
