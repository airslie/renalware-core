FactoryBot.define do
  factory :internal_message, class: "Renalware::Messaging::Internal::Message" do
    body { "The body" }
    subject { "The subject" }

    urgent { false }
    author factory: :internal_author
    sent_at { Time.zone.now }
    patient factory: :messaging_patient
    public { true }
    receipts { [] }
  end
end
