log '--------------------Adding PdToHaemodialysis--------------------'

PdToHaemodialysis.find_or_create_by!(rr_code: 201, description: "Patient/partner choice")
PdToHaemodialysis.find_or_create_by!(rr_code: 202, description: "Loss of supporting partner")
PdToHaemodialysis.find_or_create_by!(rr_code: 203, description: "Other change of personal circumstances")
PdToHaemodialysis.find_or_create_by!(rr_code: 204, description: "Inability to perform PD")
PdToHaemodialysis.find_or_create_by!(rr_code: 205, description: "Other reasons")
PdToHaemodialysis.find_or_create_by!(rr_code: 211, description: "Frequent/Recurrent peritonitis with or without loss of UF")
PdToHaemodialysis.find_or_create_by!(rr_code: 212, description: "Unresolving peritonitis")
PdToHaemodialysis.find_or_create_by!(rr_code: 213, description: "Catheter loss through exit site infection")
PdToHaemodialysis.find_or_create_by!(rr_code: 214, description: "Loss of UF")
PdToHaemodialysis.find_or_create_by!(rr_code: 215, description: "Inadequate clearance")
PdToHaemodialysis.find_or_create_by!(rr_code: 216, description: "Abdominal surgery or complications")

log '--------------------Adding HaemodialysisToPd--------------------'

HaemodialysisToPd.find_or_create_by!(rr_code: 221, description: "Patient/partner choice")
HaemodialysisToPd.find_or_create_by!(rr_code: 222, description: "Loss of supporting partner")
HaemodialysisToPd.find_or_create_by!(rr_code: 223, description: "Other change of personal circumstances")
HaemodialysisToPd.find_or_create_by!(rr_code: 224, description: "Lack of HD facilities")
HaemodialysisToPd.find_or_create_by!(rr_code: 225, description: "Other reasons")
HaemodialysisToPd.find_or_create_by!(rr_code: 231, description: "Loss of vascular access")
HaemodialysisToPd.find_or_create_by!(rr_code: 232, description: "Haemodynamic instability")
HaemodialysisToPd.find_or_create_by!(rr_code: 233, description: "Elective after temporary HD")
