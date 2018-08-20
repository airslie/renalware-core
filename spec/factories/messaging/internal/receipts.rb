# frozen_string_literal: true

FactoryBot.define do
  factory :internal_receipt, class: "Renalware::Messaging::Internal::Receipt" do
    association :recipient, factory: :internal_recipient
    read_at { nil }
    association :message, factory: :internal_message
  end
end
