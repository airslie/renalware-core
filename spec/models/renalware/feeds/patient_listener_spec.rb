# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Feeds
    describe PatientListener do
      describe "#patient_added" do
        it "delegates to another object to replay (and thus import) historical pathology" do
          patient = nil
          allow(ReplayHistoricalHL7PathologyMessages).to receive(:call)

          described_class.new.patient_added(patient)

          expect(ReplayHistoricalHL7PathologyMessages).to have_received(:call).with(patient)
        end
      end
    end
  end
end
