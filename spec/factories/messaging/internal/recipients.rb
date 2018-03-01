# frozen_string_literal: true

FactoryBot.define do
  factory :internal_recipient,
          class: "Renalware::Messaging::Internal::Recipient",
          parent: :user
end
