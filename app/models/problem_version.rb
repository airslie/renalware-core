class ProblemVersion < Version
  self.table_name = "problem_versions"
  default_scope { where.not(event: 'create') } 
end