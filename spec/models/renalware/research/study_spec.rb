require "rails_helper"

module Renalware
  RSpec.describe Research::Study, type: :model do
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to have_db_index(:code) }
    it { is_expected.to have_db_index(:description) }
    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
  end
end
