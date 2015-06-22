class Patient < ActiveRecord::Base
  include PatientsRansackHelper
  include Personable

  belongs_to :current_address, :class_name => "Address", :foreign_key => :current_address_id
  belongs_to :address_at_diagnosis, :class_name => "Address", :foreign_key => :address_at_diagnosis_id
  belongs_to :ethnicity
  belongs_to :first_edta_code, :class_name => "EdtaCode", :foreign_key => :first_edta_code_id
  belongs_to :second_edta_code, :class_name => "EdtaCode", :foreign_key => :second_edta_code_id

  has_many :exit_site_infections
  has_many :peritonitis_episodes
  has_many :events
  has_many :problems
  has_many :medications
  has_many :drugs, :through => :medications, :source => :medicatable, :source_type => "Drug"
  has_many :exit_site_infections, :through => :medications, :source => :treatable, :source_type => "ExitSiteInfection"
  has_many :peritonitis_episodes, :through => :medications, :source => :treatable, :source_type => "PeritonitisEpisode"
  has_many :medication_routes, :through => :medications
  has_many :modalities
  has_many :pd_regimes

  has_one :current_modality, -> { where deleted_at: nil }, class_name: 'Modality'
  has_one :modality_code, :through => :current_modality
  has_one :esrf_info

  accepts_nested_attributes_for :current_address
  accepts_nested_attributes_for :address_at_diagnosis
  accepts_nested_attributes_for :events
  accepts_nested_attributes_for :medications, allow_destroy: true, :reject_if => proc { |attrs|
      attrs[:medicatable_id].blank?
    }
  accepts_nested_attributes_for :problems, allow_destroy: true, reject_if: Problem.reject_if_proc
  accepts_nested_attributes_for :esrf_info

  validates :nhs_number, presence: true, length: { minimum: 10, maximum: 10 }, uniqueness: true
  validates :surname, presence: true
  validates :forename, presence: true
  validates :local_patient_id, presence: true, uniqueness: true
  validates :sex, presence: true
  validates :birth_date, presence: true

  with_options if: :current_modality_death?, on: :update do |death|
    death.validates :death_date, presence: true
    death.validates :first_edta_code_id, presence: true
  end

  scope :dead, -> { where.not(death_date: nil) }

  enum sex: { not_known: 0, male: 1, female: 2, not_specified: 9 }

  alias_attribute :first_name, :forename
  alias_attribute :last_name,  :surname

  def age
    now = Time.now.utc.to_date
    now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
  end

  # @section services

  def set_modality(attrs={})
    self.modalities << (
      if current_modality.present?
        current_modality.transfer!(attrs)
      else
        Modality.create!(attrs)
      end
    )
  end

  def current_modality_death?
    if self.current_modality.present?
      self.current_modality.modality_code.death?
    end
  end

end
