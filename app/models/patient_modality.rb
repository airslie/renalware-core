class PatientModality < ActiveRecord::Base
  include Supersedeable

  belongs_to :modality_code
  belongs_to :patient
  belongs_to :modality_reason
end
