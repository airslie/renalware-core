require "rails_helper"

module Renalware::HD
  RSpec.describe Dialyser, type: :model do
    it { is_expected.to validate_presence_of(:group) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
