module Renalware
  class Patient < ActiveRecord::Base
    include PatientsRansackHelper
    include Personable

    serialize :sex, Gender

    belongs_to :current_address, :class_name => "Address", :foreign_key => :current_address_id
    belongs_to :address_at_diagnosis, :class_name => "Address", :foreign_key => :address_at_diagnosis_id
    belongs_to :ethnicity
    belongs_to :first_edta_code, :class_name => "EdtaCode", :foreign_key => :first_edta_code_id
    belongs_to :second_edta_code, :class_name => "EdtaCode", :foreign_key => :second_edta_code_id
    belongs_to :doctor
    belongs_to :practice

    has_many :exit_site_infections
    has_many :peritonitis_episodes
    has_many :problems, class_name: "Problems::Problem"
    has_many :medications
    has_many :drugs, :through => :medications, :source => :medicatable, :source_type => "Drugs::Drug"
    has_many :exit_site_infections, :through => :medications, :source => :treatable, :source_type => "ExitSiteInfection"
    has_many :peritonitis_episodes, :through => :medications, :source => :treatable, :source_type => "PeritonitisEpisode"
    has_many :medication_routes, :through => :medications
    has_many :modalities, class_name: "Modalities::Modality"
    has_many :pd_regimes
    has_many :letters, class_name: 'Renalware::BaseLetter'
    has_many :clinic_visits

    has_one :current_modality, -> { order(started_on: :desc).where(deleted_at: nil) },
      class_name: "Modalities::Modality"
    has_one :modality_description, through: :current_modality, class_name: "Modalities::Description", source: :description
    has_one :esrf

    accepts_nested_attributes_for :current_address
    accepts_nested_attributes_for :address_at_diagnosis
    accepts_nested_attributes_for :medications, allow_destroy: true

    validates :nhs_number, presence: true, length: { minimum: 10, maximum: 10 }, uniqueness: true
    validates :family_name, presence: true
    validates :given_name, presence: true
    validates :local_patient_id, presence: true, uniqueness: true
    validates :born_on, presence: true
    validate :validate_sex

    validates :born_on, timeliness: { type: :date }

    with_options if: :current_modality_death?, on: :update do |death|
      death.validates :died_on, presence: true
      death.validates :died_on, timeliness: { type: :date }
      death.validates :first_edta_code_id, presence: true
    end

    scope :dead, -> { where.not(died_on: nil) }

    def self.policy_class
      BasePolicy
    end

    def age
      now = Time.now.utc.to_date
      now.year - born_on.year - (
        (now.month > born_on.month ||
          (now.month == born_on.month && now.day >= born_on.day)
        ) ? 0 : 1
      )
    end

    # @section services

    def set_modality(attrs)
      new_modality = if current_modality.present?
        current_modality.transfer!(attrs)
      else
        modalities.create(attrs)
      end
    end

    def current_modality_death?
      if self.current_modality.present?
        self.current_modality.description.death?
      end
    end

    def current_modality_live_donor?
      if self.current_modality.present?
        self.current_modality.description.donation?
      end
    end

    private

    def validate_sex
      errors.add(:sex, "is invalid option (#{sex.code})") unless sex.valid?
    end
  end
end
