require "rails_helper"

module Renalware::Feeds
  RSpec.describe File do
    subject { Renalware::Feeds::File.new }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to respond_to(:by=) }

    it { is_expected.to belong_to(:file_type) }
  end
end
