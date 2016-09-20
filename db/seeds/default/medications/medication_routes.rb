module Renalware
  log "Adding Medication Routes"

  Medications::MedicationRoute.find_or_create_by!(code: "PO", name: "Per Oral")
  Medications::MedicationRoute.find_or_create_by!(code: "IV", name: "Intravenous")
  Medications::MedicationRoute.find_or_create_by!(code: "SC", name: "Subcutaneous")
  Medications::MedicationRoute.find_or_create_by!(code: "IM", name: "Intramuscular")
  Medications::MedicationRoute.find_or_create_by!(code: "IP", name: "Intraperitoneal")
  Medications::MedicationRoute.find_or_create_by!(code: "INH", name: "Inhaler")
  Medications::MedicationRoute.find_or_create_by!(code: "SL", name: "Sublingual")
  Medications::MedicationRoute.find_or_create_by!(code: "NG", name: "Nasogastric")
  Medications::MedicationRoute.find_or_create_by!(code: "PARENT", name: "Parenteral")
  Medications::MedicationRoute.find_or_create_by!(code: "PERCUT", name: "Percutaneous")
  Medications::MedicationRoute.find_or_create_by!(code: "TOP", name: "Topical")
  Medications::MedicationRoute.find_or_create_by!(code: "OTHER", name: "Other")
end
