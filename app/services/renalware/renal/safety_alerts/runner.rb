module Renalware
  module Renal
    module SafetyAlerts
      class Runner
        def initialize(rules: SafetyAlertRule.enabled.ordered)
          @rules = rules
        end

        def call
          rules.map { |rule| execute_rule(rule) }
        end

        private

        attr_reader :rules

        def execute_rule(rule)
          execution = rule.executions.create!(started_at: Time.zone.now)

          SafetyAlertRule.transaction(requires_new: true) do
            rows = execute_function(rule)
            created_count = create_alerts(rule, execution, rows)

            execution.finish!(
              status: "succeeded",
              matched_count: rows.length,
              created_count: created_count
            )
          end

          execution
        rescue StandardError => e
          execution&.finish!(
            status: "failed",
            matched_count: 0,
            created_count: 0,
            error_message: e.message
          )
          execution
        end

        def execute_function(rule)
          SafetyAlertRule.connection
            .select_all(Arel.sql("SELECT * FROM #{rule.quoted_function_name}()"))
            .to_a
        end

        def create_alerts(rule, execution, rows)
          rows.sum do |row|
            create_alert(rule, execution, row)
          end
        end

        def create_alert(rule, execution, row)
          SafetyAlert.transaction(requires_new: true) do
            patient_id = row.fetch("patient_id")

            alert = SafetyAlert.active.find_or_initialize_by(
              patient_id: patient_id,
              safety_alert_rule: rule
            )
            next 0 if alert.persisted?

            alert.assign_attributes(
              safety_alert_rule_execution: execution,
              rule_name: rule.name,
              alert_type: row["alert_type"],
              metadata: metadata_from(row)
            )
            alert.save!
            1
          end
        rescue ActiveRecord::RecordNotUnique
          0
        end

        def metadata_from(row)
          metadata = row["metadata"].presence || {}
          metadata = JSON.parse(metadata) if metadata.is_a?(String)

          row
            .except("patient_id", "alert_type", "metadata")
            .compact
            .merge(metadata)
        end
      end
    end
  end
end
