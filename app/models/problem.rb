class Problem < ActiveRecord::Base
  belongs_to :patient
 
  has_paper_trail :class_name => 'ProblemVersion'
  
  def history
    problem = self
    history = [problem]
    while (problem = problem.previous_version) != nil
      history << problem
    end
    history
  end

end
