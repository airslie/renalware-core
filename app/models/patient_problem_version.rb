class PatientProblemVersion < Version
  self.table_name = "patient_problem_versions"
  default_scope { where.not(event: 'create') } 
end