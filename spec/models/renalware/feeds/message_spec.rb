# frozen_string_literal: true

require "rails_helper"

module Renalware
  RSpec.describe Feeds::Message, type: :model do
    it { is_expected.to validate_presence_of(:header_id) }
    it { is_expected.to validate_presence_of(:event_code) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to respond_to(:body_hash) }
    it { is_expected.to have_db_index(:body_hash).unique(true) }
  end
end
