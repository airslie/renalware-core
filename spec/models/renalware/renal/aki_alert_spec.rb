require "rails_helper"

module Renalware
  RSpec.describe Renal::AKIAlert, type: :model do
    it { is_expected.to validate_presence_of(:patient) }
    it { is_expected.to have_db_index(:hotlist) }
    it { is_expected.to have_db_index(:action) }
  end
end
