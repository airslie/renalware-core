class PatientMedicationVersion < Version
  self.table_name = "patient_medication_versions"
  default_scope { where.not(event: 'create') } 
end
