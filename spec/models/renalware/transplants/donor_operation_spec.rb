require "rails_helper"

module Renalware
  module Transplants
    describe DonorOperation do
      let(:clinician) { create(:user, :clinician) }

      it { should belong_to :patient }
      it { should validate_presence_of :performed_on }
    end
  end
end
