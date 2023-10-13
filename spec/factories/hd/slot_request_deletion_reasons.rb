# frozen_string_literal: true

FactoryBot.define do
  factory :hd_slot_request_deletion_reason, class: "Renalware::HD::SlotRequestDeletionReason" do
    reason { "Some Reason" }
  end
end
