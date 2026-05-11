describe Renalware::Renal::SafetyAlerts::Runner do
  let(:connection) { ActiveRecord::Base.connection }
  let(:patient1) { create(:renal_patient, :minimal) }
  let(:patient2) { create(:renal_patient, :minimal) }
  let(:rule) do
    create(
      :renal_safety_alert_rule,
      name: "Positive MSSA screen",
      function_name: "renalware.test_safety_alert_rule"
    )
  end
  let(:rules_scope) { Renalware::Renal::SafetyAlertRule.where(id: rule.id) }

  before do
    patient1
    patient2
    connection.execute(<<~SQL.squish)
      CREATE OR REPLACE FUNCTION renalware.test_safety_alert_rule()
      RETURNS TABLE(
        patient_id integer,
        label text,
        patient_name text,
        mrn text,
        metadata jsonb
      )
      LANGUAGE sql
      STABLE
      AS $$
        VALUES
          (#{patient1.id}, 'MSSA screen positive'::text, 'Patient One'::text, 'MRN1'::text, '{"modality":"HD"}'::jsonb),
          (#{patient2.id}, 'MSSA screen positive'::text, 'Patient Two'::text, 'MRN2'::text, '{"modality":"HD"}'::jsonb)
      $$;
    SQL
  end

  after do
    connection.execute("DROP FUNCTION IF EXISTS renalware.test_safety_alert_rule()")
  end

  it "creates active alerts from rows returned by enabled SQL rules" do
    execution = described_class.new(rules: rules_scope).call.first

    alerts = Renalware::Renal::SafetyAlert.order(:patient_id)
    expect(alerts.map(&:patient_id)).to eq([patient1.id, patient2.id])
    expect(alerts.first).to have_attributes(
      safety_alert_rule: rule,
      safety_alert_rule_execution: execution,
      rule_name: "Positive MSSA screen",
      label: "MSSA screen positive"
    )
    expect(alerts.first.metadata).to include("mrn" => "MRN1", "modality" => "HD")
    expect(execution).to have_attributes(
      status: "succeeded",
      matched_count: 2,
      created_count: 2
    )
  end

  it "does not duplicate active alerts" do
    create(:renal_safety_alert, patient: patient1, safety_alert_rule: rule, rule_name: rule.name)

    execution = described_class.new(rules: rules_scope).call.first

    expect(Renalware::Renal::SafetyAlert.active.count).to eq(2)
    expect(execution).to have_attributes(
      matched_count: 2,
      created_count: 1
    )
  end

  it "skips concurrent duplicate active alerts without failing the execution" do
    duplicate_alert = instance_double(
      Renalware::Renal::SafetyAlert,
      persisted?: false,
      assign_attributes: true
    )
    allow(duplicate_alert)
      .to receive(:save!)
      .and_raise(ActiveRecord::RecordNotUnique.new("duplicate alert"))
    active_alerts = instance_double(ActiveRecord::Relation)
    allow(Renalware::Renal::SafetyAlert)
      .to receive(:active)
      .and_return(active_alerts)
    allow(active_alerts)
      .to receive(:find_or_initialize_by)
      .and_return(duplicate_alert)

    execution = described_class.new(rules: rules_scope).call.first

    expect(execution).to have_attributes(
      status: "succeeded",
      matched_count: 2,
      created_count: 0
    )
  end

  it "creates a new alert after a previous one for the same rule was resolved" do
    create(
      :renal_safety_alert,
      patient: patient1,
      safety_alert_rule: rule,
      rule_name: rule.name,
      deleted_at: Time.zone.now
    )

    execution = described_class.new(rules: rules_scope).call.first

    alerts = Renalware::Renal::SafetyAlert.where(patient: patient1, safety_alert_rule: rule)
    expect(alerts.count).to eq(2)
    expect(execution.created_count).to eq(2)
  end

  it "records failed executions" do
    rule.update!(function_name: "renalware.missing_safety_alert_rule")

    executions = described_class.new(rules: rules_scope).call

    execution = executions.first
    expect(execution.status).to eq("failed")
    expect(execution.error_message).to be_present
  end

  it "rolls back alerts created by a failed rule execution" do
    connection.execute(<<~SQL.squish)
      CREATE OR REPLACE FUNCTION renalware.test_safety_alert_rule()
      RETURNS TABLE(
        patient_id integer,
        label text,
        patient_name text,
        mrn text,
        metadata jsonb
      )
      LANGUAGE sql
      STABLE
      AS $$
        VALUES
          (#{patient1.id}, 'MSSA screen positive'::text, 'Patient One'::text, 'MRN1'::text, '{}'::jsonb),
          (-1, 'MSSA screen positive'::text, 'Missing Patient'::text, 'MRN2'::text, '{}'::jsonb)
      $$;
    SQL

    execution = described_class.new(rules: rules_scope).call.first

    expect(execution.status).to eq("failed")
    expect(Renalware::Renal::SafetyAlert.where(safety_alert_rule: rule)).to be_empty
  end

  it "continues executing later rules after a rule fails" do
    failing_rule = create(
      :renal_safety_alert_rule,
      name: "Broken rule",
      function_name: "renalware.missing_safety_alert_rule"
    )

    executions = described_class.new(
      rules: Renalware::Renal::SafetyAlertRule.where(id: [failing_rule.id, rule.id]).order(:name)
    ).call

    expect(executions.map(&:safety_alert_rule)).to eq([failing_rule, rule])
    expect(executions.map(&:status)).to eq(%w(failed succeeded))
    expect(Renalware::Renal::SafetyAlert.where(safety_alert_rule: rule).count).to eq(2)
  end
end
