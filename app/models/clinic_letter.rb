class ClinicLetter < Letter
  belongs_to :clinic_visit
  validates_presence_of :clinic_visit_id
end
