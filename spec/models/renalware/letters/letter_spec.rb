require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Letter, type: :model do
      it { is_expected.to validate_presence_of(:letterhead) }
      it { is_expected.to validate_presence_of(:issued_on) }
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:author) }
      it { is_expected.to validate_presence_of(:main_recipient) }
      it { is_expected.to validate_presence_of(:description) }
    end
  end
end
