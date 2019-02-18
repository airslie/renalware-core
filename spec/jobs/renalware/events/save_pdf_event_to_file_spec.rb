# frozen_string_literal: true

require "rails_helper"
require_dependency "renalware/letters"

describe Renalware::Events::SavePdfEventToFileJob do
  subject(:job) { described_class.new }

  let(:patient) do
    create(
      :letter_patient,
      local_patient_id: "123",
      family_name: "O'Farrel-Boson"
    )
  end

  let(:event) do
    create(
      :simple_event,
      date_time: Time.zone.parse("2017-12-01 09:00:00"),
      patient: patient
    )
  end

  let(:event_presenter) { Renalware::Events::EventPdfPresenter.new(event) }

  describe "#perform" do
    it "creates the specific file with the pdf event content" do
      file_path = Renalware::Engine.root.join("tmp", "test.pdf")
      create(:hospital_centre, code: Renalware.config.ukrdc_site_code)

      job.perform(event: event_presenter, file_path: file_path)

      expect(File.exist?(file_path)).to eq(true)
    end
  end
end
