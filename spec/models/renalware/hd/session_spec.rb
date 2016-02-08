require "rails_helper"

module Renalware
  module HD
    RSpec.describe Session, type: :model do
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:signed_on_by) }
      it { is_expected.to validate_presence_of(:performed_on) }
      it { is_expected.to validate_presence_of(:hospital_unit) }
      it { is_expected.to validate_presence_of(:start_time) }

      it { is_expected.to validate_timeliness_of(:performed_on) }
      it { is_expected.to validate_timeliness_of(:start_time) }
      it { is_expected.to validate_timeliness_of(:end_time) }
    end
  end
end
