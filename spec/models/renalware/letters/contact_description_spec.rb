require "rails_helper"

module Renalware
  module Letters
    RSpec.describe ContactDescription, type: :model do
      it { is_expected.to validate_presence_of(:system_code) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:position) }
    end
  end
end
