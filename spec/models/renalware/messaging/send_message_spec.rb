require "rails_helper"

module Renalware
  module Messaging
    RSpec.describe SendMessage, type: :model do
      let(:patient)    { create(:messaging_patient) }
      let(:author)     { create(:messaging_author) }
      let(:recipient1) { create(:messaging_recipient) }
      let(:recipient2) { create(:messaging_recipient) }

      let(:form) do
        MessageForm.new(
          body: "Content",
          subject: "Subject",
          recipient_ids: ["", recipient1.id, recipient2.id], # simulate select2 posting a blank
          urgent: false
        )
      end

      describe "#call" do
        context "with valid params" do
          it "saves message and 'sends' it to the correct recipients" do
            expect do
              subject.call(patient: patient,
                           author: author,
                           form: form)
            end.to change { Message.count }.by(1)

            expect(recipient1.reload.messages.count).to eq(1)
            expect(recipient2.reload.messages.count).to eq(1)
            expect(recipient1.receipts.count).to eq(1)
            expect(recipient2.receipts.count).to eq(1)

            message = Message.first
            expect(message.body).to eq("Content")
            expect(message.subject).to eq("Subject")
            expect(message.receipts.count).to eq(2)
            expect(message.receipts.map(&:read?)).to eq([false, false])
            expect(message.recipients.count).to eq(2)
            expect(message.recipients - [recipient1, recipient2]).to eq([])
          end
        end
      end
    end
  end
end
