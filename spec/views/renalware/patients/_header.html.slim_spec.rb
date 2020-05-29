# frozen_string_literal: true

require "rails_helper"

describe "renalware/patients/_header" do
  helper(Renalware::ApplicationHelper, Renalware::PatientHelper)

  it "includes the correctly formatted NHS number" do
    patient = build(:patient, nhs_number: "9999999999")

    render partial: "renalware/patients/header", locals: { patient: patient }

    expect(rendered).to include("999 999 9999")
  end
end
