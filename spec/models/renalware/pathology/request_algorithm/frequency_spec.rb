require "rails_helper"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        describe Once do
          subject(:frequency) { Once.new }

          describe "#exceeds?" do
            subject(:exceeds?) { frequency.exceeds?(1) }

            it { expect(exceeds?).to be_falsey }
          end

          describe "#once?" do
            it { expect(frequency.once?).to be_truthy }
          end
        end

        describe Always do
          subject(:frequency) { Always.new }

          describe "#exceeds?" do
            subject(:exceeds?) { frequency.exceeds?(1) }

            it { expect(exceeds?).to be_truthy }
          end

          describe "#once?" do
            it { expect(frequency.once?).to be_falsey }
          end
        end

        describe Weekly do
          subject(:frequency) { Weekly.new }

          describe "#exceeds?" do
            subject(:exceeds?) { frequency.exceeds?(days_ago) }

            context "given the days ago is 6" do
              let(:days_ago) { 6 }

              it { expect(exceeds?).to be_falsey }
            end

            context "given the days ago is 7" do
              let(:days_ago) { 7 }

              it { expect(exceeds?).to be_truthy }
            end
          end

          describe "#once?" do
            it { expect(frequency.once?).to be_falsey }
          end
        end

        describe Monthly do
          subject(:frequency) { Monthly.new }

          describe "#exceeds?" do
            subject(:exceeds?) { frequency.exceeds?(days_ago) }

            context "given the days ago is 27" do
              let(:days_ago) { 27 }

              it { expect(exceeds?).to be_falsey }
            end

            context "given the days ago is 28" do
              let(:days_ago) { 28 }

              it { expect(exceeds?).to be_truthy }
            end
          end

          describe "#once?" do
            it { expect(frequency.once?).to be_falsey }
          end
        end
      end
    end
  end
end
