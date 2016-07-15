module Renalware
  class ExitSiteInfection < ActiveRecord::Base
    include PatientScope

    belongs_to :patient

    has_many :prescriptions, as: :treatable
    has_many :medication_routes, through: :prescriptions
    has_many :patients, through: :prescriptions, as: :treatable
    has_many :infection_organisms, as: :infectable
    has_many :organism_codes, -> { uniq }, through: :infection_organisms, as: :infectable

    validates :patient, presence: true
    validates :diagnosis_date, presence: true
  end
end
