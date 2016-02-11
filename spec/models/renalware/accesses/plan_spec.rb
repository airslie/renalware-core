require "rails_helper"

module Renalware::Accesses
  RSpec.describe Plan, type: :model do
    it { is_expected.to validate_presence_of(:name) }
  end
end
