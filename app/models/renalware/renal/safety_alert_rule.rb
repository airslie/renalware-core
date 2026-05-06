module Renalware
  module Renal
    class SafetyAlertRule < ApplicationRecord
      FUNCTION_NAME_REGEX = /\A[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)?\z/i

      has_many :safety_alerts, dependent: :restrict_with_exception
      has_many :executions,
               class_name: "SafetyAlertRuleExecution",
               dependent: :restrict_with_exception

      validates :name, presence: true, uniqueness: true
      validates :function_name,
                presence: true,
                uniqueness: true,
                format: {
                  with: FUNCTION_NAME_REGEX,
                  message: "must be a PostgreSQL function name, optionally schema-qualified"
                }

      scope :enabled, -> { where(enabled: true) }
      scope :ordered, -> { order(:name) }

      def quoted_function_name
        function_name
          .split(".")
          .map { |identifier| self.class.connection.quote_table_name(identifier) }
          .join(".")
      end
    end
  end
end
