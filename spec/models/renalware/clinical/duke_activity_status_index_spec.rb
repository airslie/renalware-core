# frozen_string_literal: true

describe Renalware::Clinical::DukeActivityStatusIndex do # an event
  describe "#document" do
    subject { described_class.new.document }

    it { is_expected.to validate_presence_of(:score) }

    it do
      is_expected.to validate_numericality_of(:score)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(60)
    end
  end
end
