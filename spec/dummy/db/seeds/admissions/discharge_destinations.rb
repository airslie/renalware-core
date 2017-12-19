module Renalware
  log "Creating Admission::DischargeDestinations" do
    [
      "Home",
      "Transfer: Other Ward",
      "Transfer: Other Hosp",
      "Transfer: ITU",
      "Death"
      ].each do |destination|
        Admissions::DischargeDestination.find_or_create_by!(destination: destination)
      end
  end
end
