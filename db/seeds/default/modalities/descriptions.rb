module Renalware
  log "Adding Modality Descriptions" do

    Deaths::ModalityDescription.find_or_create_by!(name: "Death")
    Transplants::DonorModalityDescription.find_or_create_by!(name: "Live Donor")
    Transplants::RecipientModalityDescription.find_or_create_by!(name: "Transplant")
    PD::ModalityDescription.find_or_create_by!(name: "PD")
    HD::ModalityDescription.find_or_create_by!(name: "HD")
    Renal::LowClearance::ModalityDescription.find_or_create_by!(name: "Low Clearance")
  end
end
