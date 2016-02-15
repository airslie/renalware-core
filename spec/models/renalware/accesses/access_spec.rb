require "rails_helper"

module Renalware
  module Accesses
    describe Access do
      it { is_expected.to validate_presence_of(:type) }
      it { is_expected.to validate_presence_of(:site) }
      it { is_expected.to validate_presence_of(:side) }

      it { is_expected.to validate_timeliness_of(:formed_on) }
      it { is_expected.to validate_timeliness_of(:started_on) }
      it { is_expected.to validate_timeliness_of(:terminated_on) }
      it { is_expected.to validate_timeliness_of(:planned_on) }
    end
  end
end