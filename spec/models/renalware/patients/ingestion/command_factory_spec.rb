# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    module Ingestion
      describe CommandFactory do
        subject { CommandFactory.new }

        describe "for" do
          context "given a :update_person_information message type" do
            it "returns a new UpdatePatient command" do
              message = double(:message, type: :update_person_information)
              allow(message).to receive(:has_assigned_location?).and_return(false)
              actual = subject.for(message)

              expect(actual).to be_a(Commands::UpdatePatient)
            end
          end

          context "given a :add_person_information message type" do
            it "returns a new AddPatient command" do
              pending
              message = double(:message, type: :add_person_information)
              allow(message).to receive(:has_assigned_location?).and_return(false)
              actual = subject.for(message)

              expect(actual).to be_a(Commands::AddPatient)
            end
          end

          context "given a :add_patient_information message type" do
            it "returns a new AddPatient command" do
              pending
              message = double(:message, type: :add_person_information)
              allow(message).to receive(:has_assigned_location?).and_return(false)
              actual = subject.for(message)

              expect(actual).to be_a(Commands::AddPatient)
            end
          end

          context "given a :discharge_patient message type" do
            it "returns a new DischargePatient command" do
              pending
              message = double(:message, type: :discharge_patient)
              allow(message).to receive(:has_assigned_location?).and_return(false)
              actual = subject.for(message)

              expect(actual).to be_a(Commands::DischargePatient)
            end
          end

          context "given a :merge_patient message type" do
            it "returns a new MergePatient command" do
              pending
              message = double(:message, type: :merge_patient)
              allow(message).to receive(:has_assigned_location?).and_return(false)
              actual = subject.for(message)

              expect(actual).to be_a(Commands::MergePatient)
            end
          end
        end
      end
    end
  end
end
