require "rails_helper"

module Renalware
  module HD
    describe UpdateRollingPatientStatisticsJob, type: :job do
      describe "#perform" do
        it "delegates to a service object" do
          patient = Renalware::Patient.new
          expect_any_instance_of(UpdateRollingPatientStatistics).to receive(:call)
          subject.perform(patient)
        end
      end
    end
  end
end
