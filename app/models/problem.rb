class Problem < ActiveRecord::Base

  belongs_to :patient

  # has_paper_trail

  has_paper_trail :class_name => 'ProblemVersion'

end
