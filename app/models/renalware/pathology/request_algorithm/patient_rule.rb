require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class PatientRule < ActiveRecord::Base
        include FrequencyMethods

        self.table_name = "pathology_request_algorithm_patient_rules"

        belongs_to :patient, class_name: "::Renalware::Pathology::Patient"
        belongs_to :lab, class_name: "::Renalware::Pathology::Lab"

        validates :lab, presence: true
        validates :test_description, presence: true
        validates :patient_id, presence: true

        def required?
          today = Date.current

          return false unless today_within_range?(today)
          return true if last_observed_at.nil?

          days_ago_observed = today - last_observed_at.to_date

          frequency.exceeds?(days_ago_observed)
        end

        private

        def today_within_range?(today)
          return true unless start_date.present? && end_date.present?
          today.between?(start_date.to_date, end_date.to_date)
        end
      end
    end
  end
end
