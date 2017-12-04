module Renalware
  log "Adding Demo Modality Descriptions" do
    [
      "LOST",
      "Nephrology",
      "Potential LD",
      "Supportive Care",
      "Transfer Out",
      "Transplant",
      "vCKD",
      "Waiting List"
    ].each do |name|
      Modalities::Description.find_or_create_by!(name: name)
    end
  end
end
