require "rails_helper"

module Renalware
  module Renal
    describe ProfileDocument, type: :model do
      it { is_expected.to respond_to(:comorbidities) }
      it { is_expected.to respond_to(:low_clearance) }
    end
  end
end
