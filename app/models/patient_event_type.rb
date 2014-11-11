class PatientEventType < ActiveRecord::Base
  include Concerns::SoftDelete

  has_many :patient_event

  validates :name, presence: true

end
