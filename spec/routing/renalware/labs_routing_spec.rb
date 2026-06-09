describe Renalware::LabsController do
  it "routes the global lab page" do
    expect(get: "/lab").to route_to(
      controller: "renalware/labs",
      action: "show"
    )
  end

  it "routes the patient lab page" do
    expect(get: "/patients/123/lab").to route_to(
      controller: "renalware/patients/labs",
      action: "show",
      patient_id: "123"
    )
  end

  it "routes the Heidi linked account endpoint" do
    expect(post: "/patients/123/heidi_linked_account").to route_to(
      controller: "renalware/patients/heidi_linked_accounts",
      action: "create",
      patient_id: "123"
    )
  end

  it "routes the Heidi session endpoint" do
    expect(post: "/patients/123/heidi_session").to route_to(
      controller: "renalware/patients/heidi_sessions",
      action: "create",
      patient_id: "123"
    )
  end

  it "routes the Heidi session sync endpoint" do
    expect(post: "/patients/123/heidi_session_syncs/456").to route_to(
      controller: "renalware/patients/heidi_session_syncs",
      action: "create",
      patient_id: "123",
      heidi_session_id: "456"
    )
  end

  it "routes the Heidi session outputs endpoint" do
    expect(post: "/patients/123/heidi_session_outputs/456").to route_to(
      controller: "renalware/patients/heidi_session_outputs",
      action: "create",
      patient_id: "123",
      heidi_session_id: "456"
    )
  end
end
