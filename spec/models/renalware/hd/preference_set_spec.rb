require "rails_helper"

module Renalware
  module HD
    RSpec.describe PreferenceSet, type: :model do
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_timeliness_of(:entered_on) }
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to belong_to(:schedule_definition) }
    end
  end
end
