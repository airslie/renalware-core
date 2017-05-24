require "rails_helper"

module Renalware
  module Accesses
    describe Procedure do
      it { is_expected.to validate_presence_of(:type) }
      it { is_expected.to validate_presence_of(:performed_on) }
      it { is_expected.to validate_presence_of(:performed_by) }

      it { is_expected.to validate_timeliness_of(:performed_on) }
      it { is_expected.to validate_timeliness_of(:first_used_on) }
      it { is_expected.to validate_timeliness_of(:failed_on) }
      it { is_expected.to belong_to(:pd_catheter_insertion_technique) }
    end
  end
end
