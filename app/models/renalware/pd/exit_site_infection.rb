require_dependency "renalware/pd"

module Renalware
  module PD
    class ExitSiteInfection < ActiveRecord::Base
      include PatientScope

      belongs_to :patient, class_name: "Renalware::Patient"

      has_many :prescriptions, as: :treatable, class_name: "Renalware::Medications::Prescription"
      has_many :medication_routes, through: :prescriptions
      has_many :patients, through: :prescriptions, as: :treatable
      has_many :infection_organisms, as: :infectable
      has_many :organism_codes, -> { uniq }, through: :infection_organisms, as: :infectable

      validates :patient, presence: true
      validates :diagnosis_date, presence: true
    end
  end
end
