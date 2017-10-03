require "rails_helper"

module Renalware
  RSpec.describe Renal::AKIAlert, type: :model do
    it { is_expected.to validate_presence_of(:patient) }
  end
end
