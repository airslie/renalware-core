class Patient < ActiveRecord::Base
  include Concerns::Searchable

  belongs_to :current_address, :class_name => "Address", :foreign_key => :current_address_id
  belongs_to :address_at_diagnosis, :class_name => "Address", :foreign_key => :address_at_diagnosis_id
  belongs_to :ethnicity

  has_many :patient_events
  has_many :patient_medications
  has_many :drugs, :through => :patient_medications, :source => :medication, :source_type => "Esa"

  accepts_nested_attributes_for :current_address
  accepts_nested_attributes_for :address_at_diagnosis
  accepts_nested_attributes_for :patient_events
  accepts_nested_attributes_for :patient_medications, allow_destroy: true,
  :reject_if => proc { |attrs| attrs[:dose].blank? && attrs[:notes].blank? && attrs[:frequency].blank? }

  validates :nhs_number, presence: true, length: { minimum: 10, maximum: 10 }
  validates :surname, presence: true
  validates :forename, presence: true
  validates :local_patient_id, presence: true
  validates :sex, presence: true
  validates :dob, presence: true

  enum sex: { not_known: 0, male: 1, female: 2, not_specified: 9 }

  # mappings dynamic: false do
  #   indexes :forename
  #   indexes :hosp_centre_code
  # end

  def as_indexed_json(options={})
    as_json(only: %i(forename surname hosp_centre_code))
  end

  def full_name
    "#{surname}, #{forename}"
  end

  def age
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

end
