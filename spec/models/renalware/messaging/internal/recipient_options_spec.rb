# frozen_string_literal: true

require "rails_helper"

module Renalware::Messaging::Internal
  describe RecipientOptions, type: :model do
    let(:author) { create(:internal_author) }
    let(:patient_a) { create(:messaging_patient) }
    let(:patient_b) { create(:messaging_patient) }
    let(:recipient_for_message_re_patient_a) { create(:internal_recipient) }
    let(:recipient_for_message_re_patient_b) { create(:internal_recipient) }
    let(:form) do
      MessageForm.new(
        body: "Content",
        subject: "Subject",
        recipient_ids: [recipient_for_message_re_patient_a.id],
        urgent: false
      )
    end

    def send_message_about(patient:, to:)
      form = MessageForm.new(
        body: "Content..",
        subject: "Subject..",
        recipient_ids: [to.id],
        urgent: false
      )
      SendMessage.call(patient: patient, author: author, form: form)
    end

    describe "#to_h" do
      it "returns a hash of Groups" do
        send_message_about(patient: patient_a, to: recipient_for_message_re_patient_a)
        send_message_about(patient: patient_b, to: recipient_for_message_re_patient_b)

        # Lets get grouped dropdown options as if we again want to send a message about patient_a
        recipient_options = described_class.new(patient_a, author)

        groups = recipient_options.to_a

        expect(groups).to be_a(Array)
        expect(groups.length).to eq(3)

        # The groups should reflect recent message activity, in particular the first group of users
        # should contain recipient_for_message_re_patient_a as they were recently messaged about
        # this patient. We also allow sending to self/author
        recent_patient_recipients = groups[0]
        expect(recent_patient_recipients).to be_a(RecipientOptions::Group)
        expect(recent_patient_recipients.users.count).to eq(2)
        users = recent_patient_recipients.users
        expect(users).to include(recipient_for_message_re_patient_a)
        expect(users).to include(Renalware::Messaging::Internal.cast_recipient(author))

        # The second group contains recently message by the the current author, where not not in
        # the first group already.
        recent_recipients_sent_by_author = groups[1]
        expect(recent_recipients_sent_by_author.users).to eq([recipient_for_message_re_patient_b])

        # Everyone else excluding anyone already listed and the current author
        all_other_users = groups[2]
        expect(all_other_users.users).not_to include(recipient_for_message_re_patient_a)
        expect(all_other_users.users).not_to include(recipient_for_message_re_patient_b)
        expect(all_other_users.users).not_to include(author)
      end
    end
  end
end
