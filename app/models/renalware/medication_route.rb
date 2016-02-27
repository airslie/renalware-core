module Renalware
  class MedicationRoute < ActiveRecord::Base
    has_many :medications
    has_many :patients, through: :medications
    has_many :exit_site_infections, through: :medications,
      source: :treatable, source_type: "ExitSiteInfection"
    has_many :peritonitis_episodes, through: :medications,
      source: :treatable, source_type: "PeritonitisEpisode"

    def other?
      code == "Other"
    end
  end
end
