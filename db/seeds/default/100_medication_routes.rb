log '--------------------Adding MedicationRoutes--------------------'

MedicationRoute.find_or_create_by!(name: "PO", full_name: "Per Oral")
MedicationRoute.find_or_create_by!(name: "IV", full_name: "Intravenous")
MedicationRoute.find_or_create_by!(name: "SC", full_name: "Subcutaneous")
MedicationRoute.find_or_create_by!(name: "IM", full_name: "Intramuscular")
MedicationRoute.find_or_create_by!(name: "Route: Other (Please specify in notes)", full_name: "Route: Other (Refer to medication notes)")
