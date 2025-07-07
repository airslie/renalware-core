# frozen_string_literal: true

describe Renalware::Clinical::DukeActivityStatusIndex do # an event
  subject(:model) { build(:duke_activity_status_index, document:) }

  let(:document) { { score: 1 } }

  it { is_expected.to be_valid }

  context "when missing score" do
    let(:document) { {} }

    it { is_expected.not_to be_valid }
  end
end
