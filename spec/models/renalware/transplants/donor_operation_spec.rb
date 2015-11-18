require "rails_helper"

module Renalware
  module Transplants
    describe DonorOperation do
      let(:clinician) { create(:user, :clinician) }

      it { is_expected.to validate_presence_of(:performed_on) }
    end
  end
end
