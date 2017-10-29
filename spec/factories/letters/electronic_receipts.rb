FactoryBot.define do
  factory :letter_electronic_receipt, class: "Renalware::Letters::ElectronicReceipt" do
    association :letter, factory: :letter
    association :recipient, factory: :user
  end
end
