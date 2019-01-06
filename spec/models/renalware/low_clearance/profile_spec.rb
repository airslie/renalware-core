# frozen_string_literal: true

require "rails_helper"

module Renalware
  module LowClearance
    describe Profile, type: :model do
      it_behaves_like "an Accountable model"
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to respond_to(:document) }
      it { is_expected.to be_versioned }
      it { is_expected.to have_db_index(:document) }
      it { is_expected.to have_db_index(:patient_id) }
    end
  end
end
