# frozen_string_literal: true

FactoryBot.define do
  factory :internal_message, class: "Renalware::Messaging::Internal::Message" do
    body { "The body" }
    subject { "The subject" }

    urgent { false }
    association :author, factory: :author
    sent_at { Time.zone.now }
    patient
    public { true }
    receipts { [] }
  end
end
