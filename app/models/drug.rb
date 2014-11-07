class Drug < ActiveRecord::Base

  has_many :drugs_patients
  has_many :patients, :through => :drugs_patients

  validates :name, presence: true
  validates :type, presence: true

end
