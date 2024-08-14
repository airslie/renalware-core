# frozen_string_literal: true

module Renalware::Letters::Transports::Mesh
  describe ReconcileOperationsJob do
    include LettersSpecHelper
    include MeshSpecHelper

    let(:user) { create(:user) }
    let(:letter) { create_mesh_letter_to_gp(create_mesh_patient(user: user), user) }

    it "ignores Transmissions with no operations" do
      transmission = Transmission.create!(letter: letter)

      expect {
        described_class.perform_now
      }.not_to change { transmission.reload.status }
    end

    describe "operation errors" do
      it "does not touch Transmissions having non-download/send operation errors" do
        # Note this test scenario using 'handshake' is very unlikely (this operation should not be
        # associated with a transmission) but bolt and braces anyway.
        transmission = Transmission.create!(letter: letter)
        transmission.operations.create!(action: "handshake", http_error: true)

        expect {
          described_class.perform_now
        }.not_to change { transmission.reload.status }
      end

      it "flags pending transmissions as failed if any download_message operation has an error" do
        [
          :http_error,
          :mesh_error,
          :itk3_error
        ].each do |attr_name|
          transmission = Transmission.create!(letter: letter)
          transmission.operations.create!(action: "download_message", attr_name => true)

          expect {
            described_class.perform_now
          }.to change { transmission.reload.status }.from("pending").to("failure")
        end
      end

      it "flags pending transmissions as failed if any send_message operation has an error" do
        [
          :http_error,
          :mesh_error,
          :itk3_error
        ].each do |attr_name|
          transmission = Transmission.create!(letter: letter)
          transmission.operations.create!(action: "send_message", attr_name => true)

          expect {
            described_class.perform_now
          }.to change { transmission.reload.status }.from("pending").to("failure")
        end
      end
    end

    it "flag pending transmission as success if it has success inf and bus download operations" do
      transmission = Transmission.create!(letter: letter, status: :pending)
      transmission.operations.create!(
        action: "download_message",
        itk3_response_type: "bus",
        itk3_operation_outcome_code: "30001"
      )
      transmission.operations.create!(
        action: "download_message",
        itk3_response_type: "inf",
        itk3_operation_outcome_code: "20013"
      )
      letter.update_column(:gp_send_status, "pending")

      expect {
        described_class.perform_now
      }.to change { transmission.reload.status }.from("pending").to("success")
      .and change { transmission.letter.gp_send_status }.from("pending").to("success")
    end

    describe "no MESH response after configured period elapsed" do
      it "flags transmission as failed when x hours have elapsed and no response forthcoming" do
        # Create transmission with a successful send operation
        transmission = Transmission.create!(letter: letter, status: :pending)
        transmission.operations.create!(action: "send_message")

        # Before the period has elapsed, no change
        expect {
          described_class.perform_now
        }.not_to change { transmission.reload.status }

        pending "implement me"

        # After the period has elapsed, new status will be failure as no corresponding
        # inf and bus responses to our send_message operation have been received.
        travel_to 1.year.from_now do # TODO: use config value
          expect {
            described_class.perform_now
          }.to change { transmission.reload.status }.from("pending").to("failure")
        end
      end
    end
  end
end
