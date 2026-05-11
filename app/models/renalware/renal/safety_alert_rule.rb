module Renalware
  module Renal
    class SafetyAlertRule < ApplicationRecord
      FUNCTION_NAME_REGEX = /\A[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)?\z/i

      belongs_to :safety_alert_rule_category

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
      scope :for_filter, lambda {
        joins(:safety_alert_rule_category)
          .merge(SafetyAlertRuleCategory.ordered)
          .order(:name)
      }

      def self.grouped_options_for_select
        for_filter
          .includes(:safety_alert_rule_category)
          .group_by(&:safety_alert_rule_category)
          .map do |category, rules|
            [
              category.name,
              rules.map { |rule| [rule.name, rule.id] }
            ]
          end
      end

      def quoted_function_name
        function_name
          .split(".")
          .map { |identifier| self.class.connection.quote_table_name(identifier) }
          .join(".")
      end

      def function_definition
        row = self.class.connection.select_one(
          self.class.sanitize_sql_array(
            [
              <<~SQL.squish,
                SELECT pg_get_functiondef(pg_proc.oid) AS definition
                FROM pg_proc
                JOIN pg_namespace ON pg_namespace.oid = pg_proc.pronamespace
                WHERE pg_namespace.nspname = ?
                AND pg_proc.proname = ?
                AND pg_proc.pronargs = 0
                ORDER BY pg_proc.oid
                LIMIT 1
              SQL
              function_schema,
              function_basename
            ]
          )
        )

        row&.fetch("definition", nil)
      end

      def function_definition_available?
        function_definition.present?
      end

      private

      def function_schema
        function_name.split(".").length == 2 ? function_name.split(".").first : "renalware"
      end

      def function_basename
        function_name.split(".").last
      end
    end
  end
end
