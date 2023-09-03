# frozen_string_literal: true

require "rails_helper"

module Renalware::Feeds
  describe ReplayRequest do
    subject { described_class.new }

    it :aggregate_failures do
      is_expected.to validate_presence_of(:started_at)
      is_expected.to have_many :message_replays
    end
  end
end
