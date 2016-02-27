module Renalware
  log '--------------------Adding MedicationRoutes--------------------'

  MedicationRoute.find_or_create_by!(code: "PO", name: "Per Oral")
  MedicationRoute.find_or_create_by!(code: "IV", name: "Intravenous")
  MedicationRoute.find_or_create_by!(code: "SC", name: "Subcutaneous")
  MedicationRoute.find_or_create_by!(code: "IM", name: "Intramuscular")
  MedicationRoute.find_or_create_by!(code: "Other", name: "Other")
end
