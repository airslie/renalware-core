# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Clinical
    describe BodyComposition, type: :model do
      it_behaves_like "an Accountable model"
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to belong_to(:assessor) }
      it { is_expected.to belong_to(:modality_description) }
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:assessor) }
      it { is_expected.to validate_presence_of(:total_body_water) }
      it { is_expected.to validate_presence_of(:assessed_on) }
      it { is_expected.to validate_timeliness_of(:assessed_on) }
    end
  end
end
