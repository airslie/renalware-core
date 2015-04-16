class Patient < ActiveRecord::Base
  include Concerns::Searchable

  belongs_to :current_address, :class_name => "Address", :foreign_key => :current_address_id
  belongs_to :address_at_diagnosis, :class_name => "Address", :foreign_key => :address_at_diagnosis_id
  belongs_to :ethnicity
  belongs_to :first_edta_code, :class_name => "EdtaCode", :foreign_key => :first_edta_code_id
  belongs_to :second_edta_code, :class_name => "EdtaCode", :foreign_key => :second_edta_code_id

  has_many :exit_site_infections
  has_many :peritonitis_episodes
  has_many :patient_events
  has_many :patient_problems
  has_many :medications
  has_many :active_medications, -> { where deleted_at: nil }, class_name: "Medication"
  has_many :drugs, :through => :medications, :source => :medicatable, :source_type => "Drug"
  has_many :exit_site_infections, :through => :medications, :source => :treatable, :source_type => "ExitSiteInfection"
  has_many :peritonitis_episodes, :through => :medications, :source => :treatable, :source_type => "PeritonitisEpisode"
  has_many :medication_routes, :through => :medications
  has_many :patient_modalities

  has_one :patient_modality, -> { where deleted_at: nil }
  has_one :modality_code, :through => :patient_modality
  has_one :esrf_info

  accepts_nested_attributes_for :current_address
  accepts_nested_attributes_for :address_at_diagnosis
  accepts_nested_attributes_for :patient_events
  accepts_nested_attributes_for :medications, allow_destroy: true,
  :reject_if => proc { |attrs| attrs[:dose].blank? && attrs[:notes].blank? && attrs[:frequency].blank? }
  accepts_nested_attributes_for :patient_problems, allow_destroy: true,
  :reject_if => proc { |attrs| attrs[:description].blank? }
  accepts_nested_attributes_for :patient_modality
  accepts_nested_attributes_for :esrf_info

  validates :nhs_number, presence: true, length: { minimum: 10, maximum: 10 }, uniqueness: true
  validates :surname, presence: true
  validates :forename, presence: true
  validates :local_patient_id, presence: true, uniqueness: true
  validates :sex, presence: true
  validates :dob, presence: true

  enum sex: { not_known: 0, male: 1, female: 2, not_specified: 9 }

  # mappings dynamic: false do
  #   indexes :forename
  #   indexes :hosp_centre_code
  # end

  def as_indexed_json(options={})
    as_json(only: %i(forename surname local_patient_id nhs_number))
  end

  def full_name
    "#{surname}, #{forename[0]}"
  end

  def age
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

end
