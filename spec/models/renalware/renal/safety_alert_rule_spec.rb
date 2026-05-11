describe Renalware::Renal::SafetyAlertRule do
  it :aggregate_failures do
    is_expected.to belong_to(:safety_alert_rule_category)
    is_expected.to validate_presence_of(:name)
    is_expected.to validate_presence_of(:function_name)
  end

  it "validates function names are schema-qualified identifiers, not arbitrary SQL" do
    rule = build(:renal_safety_alert_rule, function_name: "renalware.fn; drop table patients")

    expect(rule).not_to be_valid
    expect(rule.errors[:function_name]).to be_present
  end

  it "quotes a schema-qualified function name for execution" do
    rule = build(:renal_safety_alert_rule, function_name: "renalware.example_safety_alert_rule")

    expect(rule.quoted_function_name).to eq('"renalware"."example_safety_alert_rule"')
  end

  describe "#function_definition" do
    after do
      described_class.connection.execute(
        "DROP FUNCTION IF EXISTS renalware.test_safety_alert_rule_definition()"
      )
      described_class.connection.execute(
        "DROP FUNCTION IF EXISTS renalware.test_safety_alert_rule_definition(integer)"
      )
    end

    it "returns the installed PostgreSQL function definition" do
      described_class.connection.execute(<<~SQL.squish)
        CREATE OR REPLACE FUNCTION renalware.test_safety_alert_rule_definition()
        RETURNS TABLE(patient_id integer, label text, metadata jsonb)
        LANGUAGE sql
        STABLE
        AS $$
          SELECT 1, 'Test alert'::text, '{}'::jsonb
        $$;
      SQL

      rule = build(
        :renal_safety_alert_rule,
        function_name: "renalware.test_safety_alert_rule_definition"
      )

      expect(rule.function_definition).to include("test_safety_alert_rule_definition")
      expect(rule.function_definition).to include("Test alert")
    end

    it "returns the zero-argument function definition when overloaded functions exist" do
      described_class.connection.execute(<<~SQL.squish)
        CREATE OR REPLACE FUNCTION renalware.test_safety_alert_rule_definition()
        RETURNS TABLE(patient_id integer, label text, metadata jsonb)
        LANGUAGE sql
        STABLE
        AS $$
          SELECT 1, 'Zero argument alert'::text, '{}'::jsonb
        $$;
      SQL
      described_class.connection.execute(<<~SQL.squish)
        CREATE OR REPLACE FUNCTION renalware.test_safety_alert_rule_definition(patient_id integer)
        RETURNS TABLE(patient_id integer, label text, metadata jsonb)
        LANGUAGE sql
        STABLE
        AS $$
          SELECT patient_id, 'Overloaded alert'::text, '{}'::jsonb
        $$;
      SQL

      rule = build(
        :renal_safety_alert_rule,
        function_name: "renalware.test_safety_alert_rule_definition"
      )

      expect(rule.function_definition).to include("Zero argument alert")
      expect(rule.function_definition).not_to include("Overloaded alert")
    end

    it "returns nil when the function is unavailable" do
      rule = build(:renal_safety_alert_rule, function_name: "renalware.missing_rule")

      expect(rule.function_definition).to be_nil
    end
  end
end
