require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Archive, type: :model do
      it { is_expected.to validate_presence_of(:created_by) }
      it { is_expected.to validate_presence_of(:content) }
    end
  end
end
