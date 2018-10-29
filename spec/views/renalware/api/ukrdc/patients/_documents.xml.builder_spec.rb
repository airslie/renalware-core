# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "Document element" do
  helper(Renalware::ApplicationHelper)
  subject do
    render partial: "renalware/api/ukrdc/patients/documents.xml.builder",
           locals: {
             patient: patient_presenter,
             builder: Builder::XmlMarkup.new
           }
  end

  let(:patient) do
    build_stubbed(:letter_patient, family_name: "Jones", local_patient_id: "1")
  end

  let(:patient_presenter) do
    Renalware::UKRDC::PatientPresenter.new(patient)
  end

  context "when there are no letters" do
    it { is_expected.to include("<Documents></Documents>") }
  end

  context "when there is a letter" do
    let(:time) { Time.zone.now }
    let(:letter) {
      Renalware::Letters::Letter::Approved.new(
        created_at: time,
        issued_on: time.to_date,
        patient: patient,
        id: 12
      )
    }
    let(:presenter) { Renalware::Letters::LetterPresenterFactory.new(letter) }

    before do
      allow(patient_presenter).to receive(:letters).and_return([presenter])
      allow(letter).to receive(:author).and_return(instance_double(Renalware::User, username: "x"))
      allow(presenter).to receive(:hospital_unit_code).and_return("HC")
      allow(Renalware::Letters::PdfRenderer).to receive(:call).and_return("")
    end

    it { is_expected.to include("<FileType>application/pdf</FileType>") }
    it { is_expected.to include("<Stream>") }
    it { is_expected.to include("<DocumentName>JONES-1-12.pdf</DocumentName>") }
    it { is_expected.to include("<FileName>JONES-1-12.pdf</FileName>") }
    it { is_expected.to include("<DocumentTime>#{time.to_date.to_time.iso8601}</DocumentTime>") }
  end
end
