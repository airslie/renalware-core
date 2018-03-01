# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "Document element" do
  helper(Renalware::ApplicationHelper)
  let(:patient) { instance_double(Renalware::UKRDC::PatientPresenter, letters: []) }
  subject do
    render partial: "renalware/api/ukrdc/patients/documents.xml.builder",
           locals: {
             patient: patient,
             builder: Builder::XmlMarkup.new
           }
  end

  context "when there are no letters" do
    it { is_expected.to include("<Documents></Documents>") }
  end

  context "when there is a letter" do
    let(:time) { Time.zone.now }
    let(:letter) {
      Renalware::Letters::Letter::Approved.new(created_at: time, issued_on: time.to_date)
    }
    let(:presenter) { Renalware::Letters::LetterPresenterFactory.new(letter) }
    before do
      allow(patient).to receive(:letters).and_return([presenter])
      allow(letter).to receive(:author).and_return(instance_double(Renalware::User, username: "x"))
      allow(presenter).to receive(:hospital_unit_code).and_return("HC")
      allow(Renalware::Letters::PdfRenderer).to receive(:call).and_return("")
    end
    it { is_expected.to include("<FileType>application/pdf</FileType>") }
    it { is_expected.to include("<Stream>") }
    # yes this awful: trying to get e.g. 2018-01-24T00:00:00+00:00 as we have no time on
    # issued_on.
    it { is_expected.to include("<DocumentTime>#{time.to_date.to_time.iso8601}</DocumentTime>") }
  end
end
