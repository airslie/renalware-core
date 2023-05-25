# frozen_string_literal: true

FactoryBot.define do
  factory :letter_electronic_receipt, class: "Renalware::Letters::ElectronicReceipt" do
    letter
    recipient factory: %i(user)
  end
end
