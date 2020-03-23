# frozen_string_literal: true

# rubocop:disable Layout/LineLength
module Renalware
  log "Adding PD To Haemodialysis (Reasons for Change)" do
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 201, description: "Patient/partner choice")
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 202, description: "Loss of supporting partner")
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 203, description: "Other change of personal circumstances")
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 204, description: "Inability to perform PD")
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 205, description: "Other reasons")
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 211, description: "Frequent/Recurrent peritonitis with or without loss of UF")
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 212, description: "Unresolving peritonitis")
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 213, description: "Catheter loss through exit site infection")
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 214, description: "Loss of UF")
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 215, description: "Inadequate clearance")
    Modalities::PDToHaemodialysis.find_or_create_by!(rr_code: 216, description: "Abdominal surgery or complications")
  end

  log "Adding Haemodialysis To PD (Reasons for Change)" do
    Modalities::HaemodialysisToPD.find_or_create_by!(rr_code: 221, description: "Patient/partner choice")
    Modalities::HaemodialysisToPD.find_or_create_by!(rr_code: 222, description: "Loss of supporting partner")
    Modalities::HaemodialysisToPD.find_or_create_by!(rr_code: 223, description: "Other change of personal circumstances")
    Modalities::HaemodialysisToPD.find_or_create_by!(rr_code: 224, description: "Lack of HD facilities")
    Modalities::HaemodialysisToPD.find_or_create_by!(rr_code: 225, description: "Other reasons")
    Modalities::HaemodialysisToPD.find_or_create_by!(rr_code: 231, description: "Loss of vascular access")
    Modalities::HaemodialysisToPD.find_or_create_by!(rr_code: 232, description: "Haemodynamic instability")
    Modalities::HaemodialysisToPD.find_or_create_by!(rr_code: 233, description: "Elective after temporary HD")
  end
end
# rubocop:enable Layout/LineLength
