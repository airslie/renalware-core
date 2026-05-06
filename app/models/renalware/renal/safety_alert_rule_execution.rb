module Renalware
  module Renal
    class SafetyAlertRuleExecution < ApplicationRecord
      STATUSES = %w(running succeeded failed).freeze

      belongs_to :safety_alert_rule
      has_many :safety_alerts, dependent: :restrict_with_exception

      validates :started_at, presence: true
      validates :status, presence: true, inclusion: { in: STATUSES }
      validates :matched_count, :created_count, numericality: { greater_than_or_equal_to: 0 }

      scope :ordered, -> { order(started_at: :desc) }

      def finish!(status:, matched_count:, created_count:, error_message: nil)
        now = Time.zone.now
        update!(
          status: status,
          finished_at: now,
          matched_count: matched_count,
          created_count: created_count,
          duration_ms: ((now - started_at) * 1000).round,
          error_message: error_message
        )
      end
    end
  end
end
