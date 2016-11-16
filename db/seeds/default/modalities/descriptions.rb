module Renalware
  log "Adding Modality Descriptions"

  Deaths::ModalityDescription.find_or_create_by!(name: "Death")
  Transplants::DonorModalityDescription.find_or_create_by!(name: "Live Donor")

  [
    "LCC",
    "LOST",
    "Nephrology",
    "Potential LD",
    "Supportive Care",
    "Transfer Out",
    "Transplant",
    "vCKD",
    "Waiting List"
  ].each do |modal_name|
    Modalities::Description.find_or_create_by!(name: modal_name)
  end

  %w(PD APD CAPD).each do |modal_name|
    PD::ModalityDescription.find_or_create_by!(name: modal_name)
  end

  %w(HD).each do |modal_name|
    HD::ModalityDescription.find_or_create_by!(name: modal_name)
  end
end
