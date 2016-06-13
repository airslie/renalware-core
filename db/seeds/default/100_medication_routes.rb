module Renalware
  log '--------------------Adding Medication Routes--------------------'

  MedicationRoute.find_or_create_by!(code: "PO", name: "Per Oral")
  MedicationRoute.find_or_create_by!(code: "IV", name: "Intravenous")
  MedicationRoute.find_or_create_by!(code: "SC", name: "Subcutaneous")
  MedicationRoute.find_or_create_by!(code: "IM", name: "Intramuscular")
  MedicationRoute.find_or_create_by!(code: "IP", name: "Intraperitoneal")
  MedicationRoute.find_or_create_by!(code: "INH", name: "Inhaler")
  MedicationRoute.find_or_create_by!(code: "SL", name: "Sublingual")
  MedicationRoute.find_or_create_by!(code: "NG", name: "Nasogastric")
  MedicationRoute.find_or_create_by!(code: "PARENT", name: "Parenteral")
  MedicationRoute.find_or_create_by!(code: "PERCUT", name: "Percutaneous")
  MedicationRoute.find_or_create_by!(code: "TOP", name: "Topical")
  MedicationRoute.find_or_create_by!(code: "OTHER", name: "Other")
end
