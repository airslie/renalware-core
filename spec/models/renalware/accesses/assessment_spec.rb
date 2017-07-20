require "rails_helper"

module Renalware
  module Accesses
    describe Assessment do
      it { is_expected.to validate_presence_of(:type) }
      it { is_expected.to validate_presence_of(:side) }
      it { is_expected.to validate_presence_of(:performed_on) }

      it { is_expected.to validate_timeliness_of(:performed_on) }
      it { is_expected.to validate_timeliness_of(:procedure_on) }

      it { is_expected.to belong_to(:patient).touch(true) }
    end
  end
end
