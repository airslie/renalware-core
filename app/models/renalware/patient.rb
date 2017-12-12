require_dependency "renalware"
require_dependency "renalware/patients"
require "document/base"

module Renalware
  class Patient < ApplicationRecord
    include PatientsRansackHelper
    include Personable
    include Accountable
    include Document::Base
    extend Enumerize
    extend FriendlyId

    # Before creation generate a UUID to use in urls with friendly_id (i.e. in #to_param)
    # Note if inserting directly into the database (bypassing Rails) this will still work as there
    # is a default new uuid value on the secure_id column
    before_create { self.secure_id ||= SecureRandom.uuid }
    before_save :upcase_local_patient_ids
    friendly_id :secure_id, use: [:finders]

    # For compactness in urls, remove the dashes, so that
    #  a12d9a8e-9cc9-4fbe-88dd-2d1c983ea04f
    # becomes
    #  a12d9a8e9cc94fbe88dd2d1c983ea04f
    def secure_id
      @secure_id_without_dashes ||= super&.gsub("-", "")
    end

    enumerize :marital_status, in: %i(married single divorced widowed)

    has_paper_trail class_name: "Renalware::Patients::Version"

    serialize :sex, Gender

    has_one :current_observation_set, class_name: "Pathology::CurrentObservationSet"
    has_one :current_address, as: :addressable, class_name: "Address"
    has_one :summary, class_name: "Patients::Summary"
    belongs_to :ethnicity, class_name: "Patients::Ethnicity"
    belongs_to :country_of_birth, class_name: "System::Country"
    belongs_to :religion, class_name: "Patients::Religion"
    belongs_to :language, class_name: "Patients::Language"
    has_many :bookmarks, class_name: "Patients::Bookmark"
    has_many :alerts, class_name: "Patients::Alert"
    has_one :worry, class_name: "Patients::Worry"

    belongs_to :first_cause, class_name: "Deaths::Cause", foreign_key: :first_cause_id
    belongs_to :second_cause, class_name: "Deaths::Cause", foreign_key: :second_cause_id

    belongs_to :primary_care_physician, class_name: "Patients::PrimaryCarePhysician"
    belongs_to :practice, class_name: "Patients::Practice"

    has_many :exit_site_infections, class_name: "PD::ExitSiteInfection"
    has_many :peritonitis_episodes, class_name: "PD::PeritonitisEpisode"
    has_many :pd_regimes, class_name: "PD::Regime"
    has_many :problems, class_name: "Problems::Problem"
    has_many :prescriptions, class_name: "Medications::Prescription"
    has_many :drugs, through: :prescriptions
    has_many :medication_routes, through: :prescriptions, class_name: "Medications::MedicationRoute"
    has_many :modalities, class_name: "Modalities::Modality"
    has_many :modality_descriptions,
             class_name: "Modalities::Description",
             through: :modalities,
             source: :description

    has_one :current_modality,
            -> { order(started_on: :desc).where(state: "current") },
            class_name: "Modalities::Modality"

    has_one :modality_description,
            through: :current_modality,
            class_name: "Modalities::Description",
            source: :description

    has_document class_name: "Renalware::PatientDocument"

    accepts_nested_attributes_for :current_address

    validates :nhs_number,
              length: { minimum: 10, maximum: 10 },
              uniqueness: { case_sensitive: false },
              allow_blank: true
    validates :family_name, presence: true
    validates :given_name, presence: true
    validates :born_on, presence: true
    validate :validate_sex
    validates :born_on, timeliness: { type: :date }
    validates :email, email: true, allow_blank: true

    with_options if: :current_modality_death?, on: :update do |death|
      death.validates :died_on, presence: true
      death.validates :died_on, timeliness: { type: :date }
      death.validates :first_cause_id, presence: true
    end

    scope :dead, -> { where.not(died_on: nil) }

    def self.policy_class
      BasePolicy
    end

    def diabetic?
      document&.diabetes&.diagnosis == true
    end

    # Overrides Personable mixin
    def to_s(format = :default)
      title_suffix = " (#{title})" if has_title?
      formatted_name = "#{family_name.upcase}, #{given_name}#{title_suffix}"
      case format
      when :default then formatted_name
      when :long then "#{formatted_name} (#{nhs_number})"
      else full_name
      end
    end

    # rubocop:disable Style/MultilineTernaryOperator
    def age
      return unless born_on
      now = Time.now.utc.to_date
      now.year - born_on.year - (
        (now.month > born_on.month ||
          (now.month == born_on.month && now.day >= born_on.day)
        ) ? 0 : 1
      )
    end

    def assigned_to_primary_care_physician?(primary_care_physician)
      self.primary_care_physician == primary_care_physician
    end

    def current_modality_death?
      return false if current_modality.blank?

      current_modality.description.is_a?(Deaths::ModalityDescription)
    end

    def hospital_identifier
      hospital_identifiers.first
    end

    def hospital_identifiers
      @patient_hospital_identifiers ||= Patients::PatientHospitalIdentifiers.new(self)
    end

    private

    # TODO: Use a constant for the max number of local patient ids
    def upcase_local_patient_ids
      self.local_patient_id = local_patient_id.upcase if local_patient_id.present?
      (2..5).each{ |index| upcase_local_patient_id(index) }
    end

    def upcase_local_patient_id(index)
      attr_name = :"local_patient_id_#{index}"
      id_value = send(attr_name)
      send("#{attr_name}=", id_value.upcase) if id_value.present?
    end

    def has_title?
      respond_to?(:title) && title.present?
    end

    def validate_sex
      errors.add(:sex, "is invalid option (#{sex.code})") unless sex.valid?
    end
  end
end
