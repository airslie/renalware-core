require "rails_helper"

module Renalware
  module HD
    describe ProfileDocument::Dialysis, type: :model do
      subject(:dialysis){ described_class.new }

      describe "validation" do
        it { is_expected.to validate_numericality_of(:blood_flow).is_greater_than_or_equal_to(50) }
        it { is_expected.to validate_numericality_of(:blood_flow).is_less_than_or_equal_to(800) }
        context "when it has sodium profiling" do
          before { dialysis.has_sodium_profiling = :yes }
          it { is_expected.to validate_presence_of(:sodium_first_half) }
          it { is_expected.to validate_presence_of(:sodium_second_half) }
        end
        context "when it doesn't have sodium profiling" do
          before { dialysis.has_sodium_profiling = :no }
          it { is_expected.not_to validate_presence_of(:sodium_first_half) }
          it { is_expected.not_to validate_presence_of(:sodium_second_half) }
        end
      end
    end
  end
end
