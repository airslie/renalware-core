# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe BioBank::Sample do
    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
    it { is_expected.to be_versioned }
    it { is_expected.to belong_to(:patient) }
    it { is_expected.to belong_to(:sample_type) }
    it { is_expected.to have_many(:aliquots) }
    it { is_expected.to validate_presence_of(:patient) }
  end
end
