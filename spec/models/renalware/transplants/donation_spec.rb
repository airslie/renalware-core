require "rails_helper"

module Renalware
  module Transplants
    describe Donation do
      let(:clinician) { create(:user, :clinician) }

      it { should belong_to :patient }
      it { should validate_presence_of :status }
    end
  end
end
