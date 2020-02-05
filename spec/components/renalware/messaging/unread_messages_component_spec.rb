# frozen_string_literal: true

require "rails_helper"

describe Renalware::Messaging::UnreadMessagesComponent, type: :component do
  def send_message_to(user)
    form = Renalware::Messaging::Internal::MessageForm.new(
      body: "Content",
      subject: "Subject",
      recipient_ids: [user.id]
    )

    Renalware::Messaging::Internal::SendMessage.call(
      author: create(:internal_author),
      patient: create(:messaging_patient),
      form: form
    )
    Renalware::Messaging::Internal::Message.first
  end

  context "when a user has unread messages" do
    it "displays the user's messages" do
      user = create(:user)
      message = send_message_to(user)

      html = render_inline(described_class, current_user: user).to_html

      expect(html).to match("Messages")

      expect(html).to match(message.subject)
    end
  end

  context "when a user has no messages" do
    it "displays a no messages message" do
      user = create(:user)

      html = render_inline(described_class, current_user: user).to_html

      expect(html).to match("Messages")
      expect(html).to match("You have no messages")
    end
  end
end
