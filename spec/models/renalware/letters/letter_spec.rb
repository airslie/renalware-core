# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Letter, type: :model do
      it { is_expected.to validate_presence_of(:letterhead) }
      it { is_expected.to validate_presence_of(:issued_on) }
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:author) }
      it { is_expected.to validate_presence_of(:main_recipient) }
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to have_many(:electronic_receipts).dependent(:destroy) }
      it { is_expected.to respond_to(:pathology_timestamp) }
      it { is_expected.to respond_to(:pathology_snapshot) }

      describe "#include_pathology_in_letter_body?" do
        let(:letterhead) do
          build_stubbed(:letter_letterhead, include_pathology_in_letter_body: true)
        end
        subject { described_class.new(letterhead: letterhead).include_pathology_in_letter_body? }

        it { is_expected.to eq(true) }
      end
    end
  end
end
