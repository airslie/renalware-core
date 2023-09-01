# frozen_string_literal: true

require "rails_helper"

module Renalware::Feeds
  describe Replay do
    subject { described_class.new }

    it :aggregate_failures do
      is_expected.to validate_presence_of(:started_at)
      is_expected.to have_many :replay_messages
    end
  end
end
