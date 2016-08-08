require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class PatientRule < ActiveRecord::Base
        include FrequencyMethods

        self.table_name = "pathology_requests_patient_rules"

        belongs_to :patient, class_name: "::Renalware::Pathology::Patient"
        belongs_to :lab, class_name: "::Renalware::Pathology::Lab"
        has_and_belongs_to_many :requests,
          class_name: "::Renalware::Pathology::Requests::Request"

        validates :lab, presence: true
        validates :test_description, presence: true
        validates :patient_id, presence: true

        OBSERVATION_REQUIRED = true
        OBSERVATION_NOT_REQUIRED = false


        def required?
          today = Date.current

          return OBSERVATION_NOT_REQUIRED unless today_within_range?(today)
          return OBSERVATION_REQUIRED if last_observed_at.nil?

          days_ago_observed = today - last_observed_at.to_date

          frequency.observation_required?(days_ago_observed)
        end

        private

        def today_within_range?(today)
          return OBSERVATION_REQUIRED unless start_date.present? && end_date.present?

          if today.between?(start_date.to_date, end_date.to_date)
            OBSERVATION_REQUIRED
          else
            OBSERVATION_NOT_REQUIRED
          end
        end
      end
    end
  end
end
