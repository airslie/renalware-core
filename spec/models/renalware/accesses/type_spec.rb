require "rails_helper"

module Renalware::Accesses
  RSpec.describe Type, type: :model do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
