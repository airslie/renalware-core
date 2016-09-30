require "rails_helper"

module Renalware
  module HD
    describe ProfileDocument::Dialysis do

      describe "validation" do
        context "when it has sodium profiling" do
          before { subject.has_sodium_profiling = :yes }
          it { is_expected.to validate_presence_of(:sodium_first_half) }
          it { is_expected.to validate_presence_of(:sodium_second_half) }
        end
        context "when it doesn't have sodium profiling" do
          before { subject.has_sodium_profiling = :no }
          it { is_expected.to_not validate_presence_of(:sodium_first_half) }
          it { is_expected.to_not validate_presence_of(:sodium_second_half) }
        end
      end
    end
  end
end
