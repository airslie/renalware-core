# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    class MedicationRoute < ApplicationRecord
      def self.table_name
        "medication_routes"
      end

      has_many :prescriptions
      has_many :patients, through: :prescriptions
      has_many :exit_site_infections,
               through: :prescriptions,
               source: :treatable,
               source_type: "ExitSiteInfection"
      has_many :peritonitis_episodes,
               through: :prescriptions,
               source: :treatable,
               source_type: "PeritonitisEpisode"

      def other?
        code == "Other"
      end
    end
  end
end
