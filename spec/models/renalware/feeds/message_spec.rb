require "rails_helper"

module Renalware
  RSpec.describe Feeds::Message, type: :model do
    it { should validate_presence_of :event_code }
    it { should validate_presence_of :body }
  end
end
