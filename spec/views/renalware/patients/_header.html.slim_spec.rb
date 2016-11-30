require "rails_helper"

describe "renalware/patients/_header" do
  it "includes the correctly formatted NHS number" do
    patient = build(:patient, nhs_number: "1234567890")
    render partial: "renalware/patients/header", locals: { patient: patient }
    expect(rendered).to include("123 456 7890")
  end
end
