describe Renalware::Admin::SafetyAlertRuleExecutionsController do
  it "exposes only the index route" do
    expect(get: "/admin/safety_alert_rule_executions").to be_routable
    expect(get: "/admin/safety_alert_rule_executions/1").not_to be_routable
    expect(post: "/admin/safety_alert_rule_executions").not_to be_routable
    expect(patch: "/admin/safety_alert_rule_executions/1").not_to be_routable
    expect(delete: "/admin/safety_alert_rule_executions/1").not_to be_routable
  end
end
