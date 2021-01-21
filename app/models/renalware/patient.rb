# frozen_string_literal: true

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
    # before_validation :strip_spaces_from_nhs_number
    friendly_id :secure_id, use: [:finders]

    # For compactness in urls, remove the dashes, so that
    #  a12d9a8e-9cc9-4fbe-88dd-2d1c983ea04f
    # becomes
    #  a12d9a8e9cc94fbe88dd2d1c983ea04f
    def secure_id
      @secure_id_without_dashes ||= super&.gsub("-", "")
    end

    def secure_id_dashed
      self[:secure_id]
    end

    enumerize :marital_status, in: %i(married single divorced widowed)

    has_paper_trail(
      versions: { class_name: "Renalware::Patients::Version" },
      on: [:create, :update, :destroy]
    )

    serialize :sex, Gender

    has_one :current_observation_set, class_name: "Pathology::CurrentObservationSet"
    has_one :current_address, as: :addressable, class_name: "Address", dependent: :destroy
    has_one :summary, class_name: "Patients::Summary"
    belongs_to :ethnicity, class_name: "Patients::Ethnicity"
    belongs_to :country_of_birth, class_name: "System::Country"
    belongs_to :religion, class_name: "Patients::Religion"
    belongs_to :language, class_name: "Patients::Language"
    belongs_to :hospital_centre, class_name: "Hospitals::Centre"
    belongs_to :named_consultant, class_name: "User"
    has_many :bookmarks, class_name: "Patients::Bookmark", dependent: :destroy
    has_many :alerts, class_name: "Patients::Alert", dependent: :destroy
    has_one :worry, class_name: "Patients::Worry", dependent: :destroy

    belongs_to :first_cause, class_name: "Deaths::Cause"
    belongs_to :second_cause, class_name: "Deaths::Cause"

    belongs_to :primary_care_physician, class_name: "Patients::PrimaryCarePhysician"
    belongs_to :practice, class_name: "Patients::Practice"

    has_many :exit_site_infections, class_name: "PD::ExitSiteInfection"
    has_many :peritonitis_episodes, class_name: "PD::PeritonitisEpisode"
    has_many :pd_regimes, class_name: "PD::Regime"
    has_many :problems, -> { ordered }, class_name: "Problems::Problem"
    has_many :prescriptions, class_name: "Medications::Prescription"
    has_many :drugs, through: :prescriptions
    has_many :medication_routes, through: :prescriptions, class_name: "Medications::MedicationRoute"
    has_many :modalities, class_name: "Modalities::Modality", dependent: :destroy
    has_many :modality_descriptions,
             class_name: "Modalities::Description",
             through: :modalities,
             source: :description

    has_one :current_modality,
            -> { order(started_on: :desc).where(state: "current") },
            class_name: "Modalities::Modality"

    has_one :previous_modality,
            -> { order(ended_on: :desc, created_at: :desc).where.not(ended_on: nil) },
            class_name: "Modalities::Modality"

    has_one :modality_description,
            through: :current_modality,
            class_name: "Modalities::Description",
            source: :description
    has_many :attachments, dependent: :destroy, class_name: "Patients::Attachment"

    has_document class_name: "Renalware::PatientDocument"

    accepts_nested_attributes_for :current_address

    validates :nhs_number,
              "renalware/patients/nhs_number" => true,
              uniqueness: { case_sensitive: false },
              allow_blank: true

    validates :local_patient_id, uniqueness: { case_sensitive: false }, allow_blank: true
    validates :local_patient_id_2, uniqueness: { case_sensitive: false }, allow_blank: true
    validates :local_patient_id_3, uniqueness: { case_sensitive: false }, allow_blank: true
    validates :local_patient_id_4, uniqueness: { case_sensitive: false }, allow_blank: true
    validates :local_patient_id_5, uniqueness: { case_sensitive: false }, allow_blank: true
    validates :family_name, presence: true
    validates :given_name, presence: true
    validates :born_on, presence: true
    validate :validate_sex
    validate :must_have_at_least_one_identifier
    validates :born_on, timeliness: { type: :date }
    validates :email, email: true, allow_blank: true
    validates :hospital_centre, presence: true

    attr_accessor :skip_death_validations

    with_options if: :validate_death_attributes?, on: :update do
      validates :died_on, presence: true
      validates :died_on, timeliness: { type: :date }
      validates :first_cause_id, presence: true
    end

    scope :dead, -> { where.not(died_on: nil) }

    delegate :patient_at?, to: :hospital_identifiers

    def self.policy_class
      ::Renalware::Patients::PatientPolicy
    end

    def diabetic?
      document&.diabetes&.diagnosis == true
    end

    # Add spacing to an NHS number e.g. "7465613493" => "746 561 3493"
    # Although this is arguably a view concern, formati
    def nhs_number_formatted
      nhs_number&.gsub(/(\d{3})(\d{3})(\d{4})/, '\1 \2 \3')
    end

    # Overrides Personable mixin
    def to_s(format = :default)
      title_suffix = " (#{title})" if has_title?
      formatted_name = "#{family_name.upcase}, #{given_name}#{title_suffix}"
      formatted_nhs_number = " (#{nhs_number})" if nhs_number.present?
      case format
      when :default then formatted_name
      when :long then "#{formatted_name}#{formatted_nhs_number}"
      else full_name
      end
    end

    def age
      Patients::CalculateAge.for(self)
    end

    def assigned_to_primary_care_physician?(primary_care_physician)
      self.primary_care_physician == primary_care_physician
    end

    def validate_death_attributes?
      current_modality_death? && !skip_death_validations
    end

    def current_modality_death?
      return false if current_modality.blank?

      current_modality.description.is_a?(Deaths::ModalityDescription)
    end

    def hospital_identifier
      hospital_identifiers.first
    end

    def hospital_identifiers
      @hospital_identifiers ||= Patients::PatientHospitalIdentifiers.new(self)
    end

    private

    def strip_spaces_from_nhs_number
      return if nhs_number.blank?

      self.nhs_number = nhs_number.delete(" ")
    end

    # Before saving, convert all the local patient ids to upper case
    # TODO: Use a constant for the max number of local patient ids
    def upcase_local_patient_ids
      self.local_patient_id = local_patient_id.upcase if local_patient_id.present?
      (2..5).each { |index| upcase_local_patient_id(index) }
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
      unless sex.valid?
        if sex.code.present?
          errors.add(:sex, "has an invalid option (#{sex.code})")
        else
          errors.add(:sex, "is required")
        end
      end
    end

    def must_have_at_least_one_identifier
      if hospital_identifiers.all.empty? && external_patient_id.blank?
        errors.add(
          :base,
          "The patient must have at least one of these numbers: "\
          "#{Renalware.config.patient_hospital_identifiers.keys.join(', ')}, "\
          "Other Hospital Number"
        )
      end
    end
  end
end
