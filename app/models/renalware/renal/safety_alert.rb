module Renalware
  module Renal
    class SafetyAlert < ApplicationRecord
      belongs_to :patient, class_name: "Renal::Patient", touch: true
      belongs_to :safety_alert_rule
      belongs_to :safety_alert_rule_execution, optional: true

      validates :patient, :safety_alert_rule, :rule_name, presence: true
      validates :patient_id,
                uniqueness: {
                  scope: :safety_alert_rule_id,
                  conditions: -> { active },
                  message: "already has an active alert for this rule"
                }

      scope :active, -> { where(deleted_at: nil) }
      scope :resolved, -> { where.not(deleted_at: nil) }
      scope :ordered, -> { order(created_at: :desc) }
      scope :with_patient_and_rule, -> { includes(:patient, :safety_alert_rule) }

      def resolve!
        update!(deleted_at: Time.zone.now)
      end
    end
  end
end
