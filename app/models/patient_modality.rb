class PatientModality < ActiveRecord::Base
  belongs_to :modality_code
  belongs_to :patient
end
