# frozen_string_literal: true

FactoryBot.define do
  factory :internal_author,
          class: "Renalware::Messaging::Internal::Author",
          parent: :user
end
