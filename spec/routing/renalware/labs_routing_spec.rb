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
end
