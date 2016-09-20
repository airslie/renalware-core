module Renalware
  log "Adding Modality Descriptions"

  log_count = 0

  Deaths::ModalityDescription.find_or_create_by!(name: "Death")
  log_count += 1
  log "Death", type: :sub
  Transplants::DonorModalityDescription.find_or_create_by!(name: "Live Donor")
  log_count += 1
  log "Live Donor", type: :sub

  [
    "LCC",
    "LOST",
    "Nephrology",
    "Potential LD",
    "Supportive Care",
    "Transfer Out",
    "Transfer Out (SPK)",
    "Transplant",
    "vCKD",
    "Waiting List"
  ].each do |modal_name|
    Modalities::Description.find_or_create_by!(name: modal_name)

    log_count += 1
    log modal_name, type: :sub
  end

  %w(PD APD CAPD).each do |modal_name|
    PD::ModalityDescription.find_or_create_by!(name: modal_name)

    log_count += 1
    log modal_name, type: :sub
  end

  %w(HD).each do |modal_name|
    HD::ModalityDescription.find_or_create_by!(name: modal_name)

    log_count += 1
    log "#{modal_name}", type: :sub
  end

  log "#{log_count} Modality Codes seeded", type: :sub
end
