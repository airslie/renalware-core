# frozen_string_literal: true

require "rails_helper"

# Removed this test as something environmental on CI is causing line 6 to complain that 
# PatientsSpecHelper is not defined, even if it is included with
#  include PatientsSpecHelper
# Nothing else has changed to provoke this. All PRs seemd to start failing together on this test.
describe "renalware/patients/_header" do
  include PatientsSpecHelper
  helper(Renalware::ApplicationHelper, Renalware::PatientHelper)

  it "includes the correctly formatted NHS number" do
    patient = build(:patient, nhs_number: "1234567890")
    render partial: "renalware/patients/header", locals: { patient: patient }
    expect(rendered).to include("123 456 7890")
  end
end
