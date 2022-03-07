# frozen_string_literal: true

module Renalware
  log "Adding Modality Descriptions" do
    Deaths::ModalityDescription.find_or_create_by!(
      name: "Death", code: "death", ignore_for_aki_alerts: true
    )
    Transplants::DonorModalityDescription.find_or_create_by!(
      name: "Live Donor", code: "live_donor"
    )
    Transplants::RecipientModalityDescription.find_or_create_by!(
      name: "Transplant", code: "transplant"
    )
    PD::ModalityDescription.find_or_create_by!(
      name: "PD", code: "pd", ignore_for_aki_alerts: true
    )
    HD::ModalityDescription.find_or_create_by!(
      name: "HD", code: "hd", ignore_for_aki_alerts: true
    )
    LowClearance::ModalityDescription.find_or_create_by!(
      name: "Advanced Kidney Care", code: "low_clearance"
    )
  end
end
