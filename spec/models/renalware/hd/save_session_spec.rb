# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    module Sessions
      RSpec.describe SaveSession, type: :command do
        include ActiveJob::TestHelper

        let(:patient) { build_stubbed(:hd_patient) }
        let(:user) { build_stubbed(:user) }

        it "expects session params to contain type" do
          obj = SaveSession.new(patient: patient, current_user: user)
          expect{ obj.call(params: {}, signing_off: false, id: nil) }.to raise_error(ArgumentError)
        end

        it "broadcasts an event on success" do
          obj = SaveSession.new(patient: patient, current_user: user)
          expect_any_instance_of(HD::Session).to receive(:save).and_return(true)
          expect {
            obj.call(params: { type: "Renalware::HD::Session::Open" })
          }.to broadcast(:save_success)
        end

        it "broadcasts an event on failure" do
          obj = SaveSession.new(patient: patient, current_user: user)
          expect_any_instance_of(HD::Session).to receive(:save).and_return(false)
          expect {
            obj.call(params: { type: "Renalware::HD::Session::Open" })
          }.to broadcast(:save_failure)
        end

        it "doesn't enqueue a request to update rolling session stats if its an open session" do
          obj = SaveSession.new(patient: patient, current_user: user)
          expect_any_instance_of(HD::Session).to receive(:save).and_return(true)

          obj.call(params: { type: "Renalware::HD::Session::Open" })
          expect(enqueued_jobs.size).to eq(0)
        end

        it "enqueues a request to update rolling session stats if its an closed session" do
          obj = SaveSession.new(patient: patient, current_user: user)
          expect_any_instance_of(HD::Session).to receive(:save).and_return(true)

          obj.call(params: { type: "Renalware::HD::Session::Closed" })
          expect(enqueued_jobs.size).to eq(1)
        end

        it "enqueues a request to update rolling session stats if its an dna session" do
          obj = SaveSession.new(patient: patient, current_user: user)
          expect_any_instance_of(HD::Session).to receive(:save).and_return(true)

          obj.call(params: { type: "Renalware::HD::Session::DNA" })
          expect(enqueued_jobs.size).to eq(1)
        end

        it "assigns the most recent hd dry weight to the session" do
          patient = create(:hd_patient)
          create(:dry_weight, patient_id: patient.id, weight: 100.0, assessed_on: 1.year.ago)
          latest_dw = create(
            :dry_weight,
            patient_id: patient.id,
            weight: 103.0,
            assessed_on: 1.day.ago
          )
          create(:dry_weight, patient_id: patient.id, weight: 99.0, assessed_on: 2.days.ago)

          # Build session params but make sure there is no dry_weight_id in there
          # as this is not usually in the params passed to SaveSession, which will lookup the latest
          # dry_weight itself. Passing it here ends up overwriting the looked-up weight.
          session_attributes = build(
            :hd_closed_session,
            hospital_unit_id: create(:hospital_unit).id
          ).attributes
          session_attributes.delete("dry_weight_id")

          obj = SaveSession.new(patient: patient, current_user: user)

          # We'll assign something to this in the save_success method below
          saved_session = nil

          # Create a listener to receive broadcast success or failure from SaveSession
          MyListener = Class.new do
            define_method :save_success, ->(session){ saved_session = session }
            define_method :save_failure, ->(_session){ fail("should not get here") }
          end
          obj.subscribe MyListener.new

          # Do the save
          obj.call(
            params: session_attributes.update(type: "Renalware::HD::Session::Open"),
            signing_off: true
          )

          expect(saved_session.dry_weight).to eq(latest_dw)
        end
      end
    end
  end
end
