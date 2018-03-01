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
      end
    end
  end
end
