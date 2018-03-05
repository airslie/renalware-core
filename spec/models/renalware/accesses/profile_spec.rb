# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Accesses
    describe Profile do
      it_behaves_like "an Accountable model"
      it { is_expected.to validate_presence_of(:type) }
      it { is_expected.to validate_presence_of(:side) }
      it { is_expected.to validate_presence_of(:formed_on) }
      it { is_expected.to validate_timeliness_of(:formed_on) }
      it { is_expected.to validate_timeliness_of(:started_on) }
      it { is_expected.to validate_timeliness_of(:terminated_on) }
      it { is_expected.to belong_to(:patient).touch(true) }
    end
  end
end
