class ClinicLetter < Letter
  belongs_to :clinic
  validates_presence_of :clinic_id
end
