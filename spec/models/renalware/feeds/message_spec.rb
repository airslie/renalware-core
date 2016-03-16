require "rails_helper"

module Renalware
  RSpec.describe Feeds::Message, type: :model do
    it { is_expected.to validate_presence_of(:event_code) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
