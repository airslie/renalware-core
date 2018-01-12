require "rails_helper"
require_dependency "models/renalware/concerns/accountable"

module Renalware
  module LowClearance
    RSpec.describe Profile, type: :model do
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to respond_to(:document) }
      it { is_expected.to be_versioned }
      it { is_expected.to have_db_index(:document) }
      it { is_expected.to have_db_index(:patient_id) }
      it_behaves_like "Accountable"
    end
  end
end
