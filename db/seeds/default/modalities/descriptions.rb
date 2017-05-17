module Renalware
  log "Adding Modality Descriptions" do

    Deaths::ModalityDescription.find_or_create_by!(name: "Death")
    Transplants::DonorModalityDescription.find_or_create_by!(name: "Live Donor")
    PD::ModalityDescription.find_or_create_by!(name: "PD")
    HD::ModalityDescription.find_or_create_by!(name: "HD")
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
  end
end
