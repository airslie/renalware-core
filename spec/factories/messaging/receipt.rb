FactoryGirl.define do
  factory :receipt, class: "Renalware::Messaging::Receipt" do
    association :recipient, factory: :recipient
    read_at nil
    association :message, factory: :internal_message
  end
end
