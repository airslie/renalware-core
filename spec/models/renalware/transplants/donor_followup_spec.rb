require "rails_helper"

module Renalware
  module Transplants
    describe DonorFollowup do
      it { is_expected.to validate_timeliness_of(:last_seen_on) }
    end
  end
end
