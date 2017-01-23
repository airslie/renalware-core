require "rails_helper"

module Renalware
  module HD
    describe SessionDocument::Dialysis, type: :model do
      describe "validation" do
        it { is_expected.to validate_numericality_of(:blood_flow).is_greater_than_or_equal_to(50) }
        it { is_expected.to validate_numericality_of(:blood_flow).is_less_than_or_equal_to(800) }
      end
    end
  end
end
