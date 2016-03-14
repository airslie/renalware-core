require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Recipient, type: :model do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:address) }
    end
  end
end