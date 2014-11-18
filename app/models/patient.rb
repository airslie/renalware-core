class Patient < ActiveRecord::Base

  belongs_to :current_address, :class_name => "Address", :foreign_key => :current_address_id
  belongs_to :address_at_diagnosis, :class_name => "Address", :foreign_key => :address_at_diagnosis_id
  belongs_to :ethnicity

  has_many :patient_events
  has_many :patient_medications
  has_many :drugs, :through => :patient_medications, :source => :medication, :source_type => "Esa"

  accepts_nested_attributes_for :current_address
  accepts_nested_attributes_for :address_at_diagnosis
  accepts_nested_attributes_for :patient_medications

  validates :nhs_number, presence: true, length: { minimum: 10, maximum: 10 }
  validates :surname, presence: true
  validates :forename, presence: true
  validates :local_patient_id, presence: true
  validates :sex, presence: true
  validates :dob, presence: true

  enum sex: { not_known: 0, male: 1, female: 2, not_specified: 9 }
  
  def full_name
    "#{surname}, #{forename}"
  end
end
