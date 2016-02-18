require "rails_helper"

module Renalware
  module Accesses
    describe Assessment do
      it { is_expected.to validate_presence_of(:type) }
      it { is_expected.to validate_presence_of(:site) }
      it { is_expected.to validate_presence_of(:side) }
      it { is_expected.to validate_presence_of(:performed_on) }

      it { is_expected.to validate_timeliness_of(:performed_on) }
      it { is_expected.to validate_timeliness_of(:procedure_on) }
    end
  end
end