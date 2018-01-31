require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Archive, type: :model do
      it_behaves_like "an Accountable model"
      it { is_expected.to validate_presence_of(:content) }
    end
  end
end
