# frozen_string_literal: true

module Renalware
  log "Adding Clinics" do
    [
      "Access",
      "AKI",
      "Anaemia",
      "CAPD",
      "CAPD Nurses",
      "Dartford Outreach",
      "Dietitians",
      "Donor Clinic",
      "Donor Screen",
      "General Nephrology",
      "Haemodialysis",
      "Home Haemodialysis",
      "Iron",
      "Advanced Kidney Care",
      "Transplant",
      "Walk-in",
      "Woolwich Outreach"
    ].each do |name|
      Clinics::Clinic.find_or_create_by!(name: name) do |clinic|
        clinic.consultant = SystemUser.find
      end
    end
  end
end
