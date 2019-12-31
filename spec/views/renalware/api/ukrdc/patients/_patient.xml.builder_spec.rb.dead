# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "_patient.xml.builder" do
  helper(Renalware::ApplicationHelper)

  it "includes the correctly formatted NHS number" do
    patient = Renalware::UKRDC::PatientPresenter.new(
      build(
        :patient,
        nhs_number: "1234567890",
        sent_to_ukrdc_at: 1.year.ago
      )
    )
    render partial: "renalware/api/ukrdc/patients/patient.xml.builder",
           locals: {
             patient: patient,
             builder: Builder::XmlMarkup.new
           }

    expect(rendered).to include("<Number>1234567890</Number>")
  end

  it "includes omits NHS number if patient has none" do
    patient = Renalware::UKRDC::PatientPresenter.new(
      build(
        :patient,
        nhs_number: nil,
        sent_to_ukrdc_at: 1.year.ago,
        local_patient_id: nil
      )
    )
    render partial: "renalware/api/ukrdc/patients/patient.xml.builder",
           locals: {
             patient: patient,
             builder: Builder::XmlMarkup.new
           }

    expect(rendered).not_to include("<Number>")
  end

  it "outputs PrimaryLanguage" do
    language = build_stubbed(:language, :english)
    patient = Renalware::UKRDC::PatientPresenter.new(
      build(
        :patient,
        sent_to_ukrdc_at: 1.year.ago,
        language: language
      )
    )
    render partial: "renalware/api/ukrdc/patients/patient.xml.builder",
           locals: {
             patient: patient,
             builder: Builder::XmlMarkup.new
           }

    expect(rendered).to include("<PrimaryLanguage>")
  end

  context "when the language is Other (ot)" do
    it "does not output it" do
      language = build_stubbed(:language, :other)
      patient = Renalware::UKRDC::PatientPresenter.new(
        build(
          :patient,
          sent_to_ukrdc_at: 1.year.ago,
          language: language
        )
      )
      render partial: "renalware/api/ukrdc/patients/patient.xml.builder",
             locals: {
               patient: patient,
               builder: Builder::XmlMarkup.new
             }

      expect(rendered).not_to include("<PrimaryLanguage>")
    end
  end
end
