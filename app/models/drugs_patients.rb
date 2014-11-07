class DrugsPatients < ActiveRecord::Base

  belongs_to :drugs
  belongs_to :patients

end
