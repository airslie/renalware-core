require "rails_helper"

module Renalware
  RSpec.describe Modalities::Description, type: :model do
    it { is_expected.to validate_presence_of :name }
  end
end
