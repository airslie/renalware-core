require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class PatientRule < ActiveRecord::Base
        include FrequencyMethods

        self.table_name = "pathology_request_algorithm_patient_rules"

        belongs_to :patient, class_name: "::Renalware::Pathology::Patient"

        validates :lab, presence: true
        validates :test_description, presence: true
        validates :frequency, presence: true
        validates :frequency, inclusion: { in: FREQUENCIES, allow_nil: true }
        validates :patient_id, presence: true

        def required?
          return false unless today_within_range?
          return true if last_observed_at.nil?

          days_ago_observed = Date.current - last_observed_at.to_date

          required_from_frequency?(frequency, days_ago_observed)
        end

        private

        def today_within_range?
          return true unless start_date.present? && end_date.present?
          Date.current.between?(start_date.to_date, end_date.to_date)
        end
      end
    end
  end
end
