require "rails_helper"

module Renalware::Accesses
  RSpec.describe Plan, type: :model do
    it_behaves_like "an Accountable model"
    it { is_expected.to validate_presence_of(:plan_type) }
    it { is_expected.to validate_presence_of(:decided_by) }
  end
end
