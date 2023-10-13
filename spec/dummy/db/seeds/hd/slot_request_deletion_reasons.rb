# frozen_string_literal: true

module Renalware
  log "Adding HD Slot Request Deletion Reasons" do
    HD::SlotRequestDeletionReason.find_or_create_by!(reason: "Deceased")
    HD::SlotRequestDeletionReason.find_or_create_by!(reason: "Recovered")
    HD::SlotRequestDeletionReason.find_or_create_by!(reason: "Started PD")
    HD::SlotRequestDeletionReason.find_or_create_by!(reason: "Transplanted")
    HD::SlotRequestDeletionReason.find_or_create_by!(reason: "Transferred out")
    HD::SlotRequestDeletionReason.find_or_create_by!(reason: "Other")
  end
end
