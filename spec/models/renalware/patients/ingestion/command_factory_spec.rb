# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    module Ingestion
      describe CommandFactory do
        subject(:factory) { CommandFactory.new }

        def message_returning_action(action)
          instance_double(Renalware::Feeds::HL7Message, action: action)
        end

        describe "#for" do
          context "when a :update_person_information message type" do
            it "returns a new UpdatePatient command" do
              expect(
                factory.for(message_returning_action(:update_person_information))
              ).to be_a(Commands::AddOrUpdatePatient)
            end
          end

          context "when a :add_person_information message type" do
            it "returns a new AddPatient command" do
              expect(
                factory.for(message_returning_action(:add_person_information))
              ).to be_a(Commands::AddOrUpdatePatient)
            end
          end

          context "when a :discharge_patient message type" do
            it "returns a new DischargePatient command" do
              pending
              expect(
                factory.for(message_returning_action(:discharge_patient))
              ).to be_a(Commands::DischargePatient)
            end
          end

          context "when a :merge_patient message type" do
            it "returns a new MergePatient command" do
              pending
              expect(
                factory.for(message_returning_action(:merge_patient))
              ).to be_a(Commands::MergePatient)
            end
          end

          context "when a :no_matching_command message type" do
            it "returns a null object" do
              expect(
                factory.for(message_returning_action(:no_matching_command))
              ).to be_a(NullObject)
            end
          end
        end
      end
    end
  end
end
