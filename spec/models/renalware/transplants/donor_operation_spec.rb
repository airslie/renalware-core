require "rails_helper"

module Renalware
  module Transplants
    describe DonorOperation do
      it { is_expected.to validate_presence_of(:performed_on) }
    end
  end
end
