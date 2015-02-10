class PatientProblem < ActiveRecord::Base
  
  acts_as_paranoid

  has_paper_trail :class_name => 'ProblemVersion'
  
  belongs_to :patient
 

end
