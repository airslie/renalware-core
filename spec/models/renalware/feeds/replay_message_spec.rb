# frozen_string_literal: true

require "rails_helper"

module Renalware::Feeds
  describe ReplayMessage do
    subject { described_class.new }

    it :aggregate_failures do
      is_expected.to validate_presence_of(:replay_id)
      is_expected.to validate_presence_of(:message_id)
      is_expected.to belong_to :replay
      is_expected.to belong_to :message
    end
  end
end
