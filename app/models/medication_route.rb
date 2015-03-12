class MedicationRoute < ActiveRecord::Base

  has_many :medications
  has_many :patients, through: :medications

end