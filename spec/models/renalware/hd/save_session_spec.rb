require "rails_helper"

module Renalware
  module HD
    module Sessions
      RSpec.describe SaveSession, type: :command do
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
        #save_failure)
      end
    end
  end
end
