class CreateRenalSafetyAlerts < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      create_table :renal_safety_alert_rules do |t|
        t.string :name, null: false
        t.string :function_name, null: false
        t.boolean :enabled, null: false, default: true

        t.timestamps null: false
      end

      add_index :renal_safety_alert_rules, :name, unique: true
      add_index :renal_safety_alert_rules, :function_name, unique: true

      create_table :renal_safety_alert_rule_executions do |t|
        t.references(
          :safety_alert_rule,
          null: false,
          foreign_key: { to_table: :renal_safety_alert_rules },
          index: { name: "idx_renal_safety_alert_rule_executions_on_rule_id" }
        )
        t.datetime :started_at, null: false
        t.datetime :finished_at
        t.string :status, null: false, default: "running"
        t.integer :matched_count, null: false, default: 0
        t.integer :created_count, null: false, default: 0
        t.integer :duration_ms
        t.text :error_message

        t.timestamps null: false
      end

      create_table :renal_safety_alerts do |t|
        t.references :patient, null: false, foreign_key: true, index: true
        t.references(
          :safety_alert_rule,
          null: false,
          foreign_key: { to_table: :renal_safety_alert_rules },
          index: true
        )
        t.references(
          :safety_alert_rule_execution,
          foreign_key: { to_table: :renal_safety_alert_rule_executions },
          index: { name: "idx_renal_safety_alerts_on_rule_execution_id" }
        )
        t.string :rule_name, null: false
        t.string :alert_type
        t.jsonb :metadata, null: false, default: {}
        t.datetime :deleted_at
        t.references :deleted_by, foreign_key: { to_table: :users }, index: true

        t.timestamps null: false
      end

      add_index(
        :renal_safety_alerts,
        %i(patient_id safety_alert_rule_id),
        unique: true,
        where: "deleted_at IS NULL",
        name: "idx_renal_safety_alerts_active_unique"
      )
      add_index :renal_safety_alerts, :deleted_at
      add_index :renal_safety_alerts, :created_at

      reversible do |dir|
        dir.up do
          safety_assured do
            execute(<<~SQL.squish)
              CREATE OR REPLACE FUNCTION renalware.example_safety_alert_rule()
              RETURNS TABLE(
                patient_id integer,
                alert_type text,
                metadata jsonb
              )
              LANGUAGE sql
              STABLE
              AS $$
                SELECT
                  patients.id AS patient_id,
                  'Example safety alert'::text AS alert_type,
                  jsonb_build_object('source', 'example') AS metadata
                FROM renalware.patients
                ORDER BY patients.id
                LIMIT 1
              $$;
            SQL

            execute(<<~SQL.squish)
              INSERT INTO renalware.renal_safety_alert_rules (
                name,
                function_name,
                enabled,
                created_at,
                updated_at
              )
              VALUES (
                'Example safety alert rule',
                'renalware.example_safety_alert_rule',
                false,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP
              )
              ON CONFLICT (function_name) DO NOTHING
            SQL
          end
        end

        dir.down do
          safety_assured do
            execute("DROP FUNCTION IF EXISTS renalware.example_safety_alert_rule()")
          end
        end
      end
    end
  end
end
