module Renalware
  log "--------------------Adding Clinics--------------------"
  [
    "Access",
    "AKI",
    "Anaemia",
    "CAPD",
    "CAPD Nurses",
    "Dartford Outreach",
    "Dietitians",
    "General Nephrology",
    "Haemodialysis",
    "Home Haemodialysis",
    "Iron",
    "Low Clearance",
    "Transplant",
    "Walk-in",
    "Woolwich Outreach"
  ].each do |name|
    Clinic.find_or_create_by!(name: name)
  end
end
