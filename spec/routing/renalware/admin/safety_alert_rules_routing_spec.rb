describe Renalware::Admin::SafetyAlertRulesController do
  it "routes command actions" do
    expect(patch: "/admin/safety_alert_rules/1/enable").to route_to(
      controller: "renalware/admin/safety_alert_rules",
      action: "enable",
      id: "1"
    )
    expect(patch: "/admin/safety_alert_rules/1/disable").to route_to(
      controller: "renalware/admin/safety_alert_rules",
      action: "disable",
      id: "1"
    )
    expect(post: "/admin/safety_alert_rules/1/run").to route_to(
      controller: "renalware/admin/safety_alert_rules",
      action: "run",
      id: "1"
    )
  end

  it "does not expose edit, create, update, or destroy routes" do
    expect(get: "/admin/safety_alert_rules/1/edit").not_to be_routable
    expect(post: "/admin/safety_alert_rules").not_to be_routable
    expect(patch: "/admin/safety_alert_rules/1").not_to be_routable
    expect(delete: "/admin/safety_alert_rules/1").not_to be_routable
  end
end
