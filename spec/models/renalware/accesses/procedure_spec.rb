require "rails_helper"

module Renalware
  module Accesses
    describe Procedure do
      it { is_expected.to validate_presence_of(:type) }
      it { is_expected.to validate_presence_of(:site) }
      it { is_expected.to validate_presence_of(:side) }
      it { is_expected.to validate_presence_of(:performed_on) }
      it { is_expected.to validate_presence_of(:performed_by) }

      it { is_expected.to validate_timeliness_of(:performed_on) }
      it { is_expected.to validate_timeliness_of(:first_used_on) }
      it { is_expected.to validate_timeliness_of(:failed_on) }
    end
  end
end