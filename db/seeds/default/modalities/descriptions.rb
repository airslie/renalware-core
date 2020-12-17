# frozen_string_literal: true

module Renalware
  log "Adding Modality Descriptions" do
    Deaths::ModalityDescription.find_or_create_by!(
      name: "Death", code: "death"
    )
    Transplants::DonorModalityDescription.find_or_create_by!(
      name: "Live Donor", code: "live_donor"
    )
    Transplants::RecipientModalityDescription.find_or_create_by!(
      name: "Transplant", code: "transplant"
    )
    PD::ModalityDescription.find_or_create_by!(
      name: "PD", code: "pd"
    )
    HD::ModalityDescription.find_or_create_by!(
      name: "HD", code: "hd"
    )
    LowClearance::ModalityDescription.find_or_create_by!(
      name: "Advanced Kidney Care", code: "low_clearance"
    )
  end
end
