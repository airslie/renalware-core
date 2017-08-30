FactoryGirl.define do
  factory :messaging_recipient,
          class: "Renalware::Messaging::Recipient",
          parent: :user
end
