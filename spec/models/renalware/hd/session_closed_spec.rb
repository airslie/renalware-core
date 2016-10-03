require "rails_helper"

module Renalware
  module HD
    RSpec.describe Session::Closed, type: :model do
      it { is_expected.to validate_presence_of(:signed_off_by) }
      it { is_expected.to validate_presence_of(:end_time) }
    end

    RSpec.describe Session::Closed::SessionDocument::Info do
      it { is_expected.to validate_presence_of(:hd_type) }
    end

    RSpec.describe SessionDocument::Info do
      it { is_expected.to_not validate_presence_of(:hd_type) }
    end
  end
end
