module Renalware
  class ExitSiteInfection < ActiveRecord::Base
    include PatientScope

    belongs_to :patient

    has_many :medications, as: :treatable
    has_many :medication_routes, through: :medications
    has_many :patients, through: :medications, as: :treatable
    has_many :infection_organisms, as: :infectable
    has_many :organism_codes, -> { uniq }, through: :infection_organisms, as: :infectable

    validates :patient, presence: true
    validates :diagnosis_date, presence: true
  end
end
