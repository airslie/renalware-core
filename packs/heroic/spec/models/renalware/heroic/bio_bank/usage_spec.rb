# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe BioBank::Usage do
    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
    it { is_expected.to be_versioned }
    it { is_expected.to belong_to(:usable) }
    it { is_expected.to have_db_index(%i(usable_type usable_id)) }
  end
end
