require "rails_helper"

module Renalware
  describe System::Country, type: :model do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:alpha2) }
    it { is_expected.to validate_presence_of(:alpha3) }
  end
end
