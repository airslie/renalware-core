require "rails_helper"
require "builder"

describe "patient" do
  helper(Renalware::ApplicationHelper)

  it "includes the correctly formatted NHS number" do
    patient = Renalware::UKRDC::PatientPresenter.new(build(:patient, nhs_number: "1234567890"))
    render partial: "renalware/api/ukrdc/patients/patient.xml.builder",
           locals: {
             patient: patient,
             builder: Builder::XmlMarkup.new
           }

    expect(rendered).to include("<Number>1234567890</Number>")
  end
end
