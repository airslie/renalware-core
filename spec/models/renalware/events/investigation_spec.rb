require "rails_helper"

describe Renalware::Events::Investigation, type: :model do
  describe "#document" do
    subject { described_class.new.document }

    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_presence_of(:result) }
  end
end
