class MedicationVersion < Version
  self.table_name = "medication_versions"
  default_scope { where.not(event: 'create') } 
end
