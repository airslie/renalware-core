# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe UpdateRollingPatientStatisticsJob, type: :job do
      subject(:job) { described_class.new }

      it { is_expected.to respond_to(:queue_name) }

      describe "#perform" do
        it "delegates to a service object" do
          patient = Renalware::Patient.new
          expect_any_instance_of(UpdateRollingPatientStatistics).to receive(:call)
          job.perform(patient)
        end
      end
    end
  end
end
