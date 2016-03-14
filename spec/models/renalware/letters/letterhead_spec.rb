require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Letterhead, type: :model do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:unit_info) }
      it { is_expected.to validate_presence_of(:trust_name) }
      it { is_expected.to validate_presence_of(:trust_caption) }
    end
  end
end