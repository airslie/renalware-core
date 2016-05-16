require "rails_helper"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        describe Once do
          describe ".exceeds?" do
            subject(:exceeds?) { Once.exceeds?(1) }

            it { expect(exceeds?).to be_falsey }
          end
        end

        describe Always do
          describe ".exceeds?" do
            subject(:exceeds?) { Always.exceeds?(1) }

            it { expect(exceeds?).to be_truthy }
          end
        end

        describe Weekly do
          subject(:exceeds?) { Weekly.exceeds?(days_ago) }

          describe ".exceeds?" do
            context "given the days ago is 6" do
              let(:days_ago) { 6 }

              it { expect(exceeds?).to be_falsey }
            end

            context "given the days ago is 7" do
              let(:days_ago) { 7 }

              it { expect(exceeds?).to be_truthy }
            end
          end
        end

        describe Monthly do
          describe ".exceeds?" do
            subject(:exceeds?) { Monthly.exceeds?(days_ago) }

            context "given the days ago is 27" do
              let(:days_ago) { 27 }

              it { expect(exceeds?).to be_falsey }
            end

            context "given the days ago is 28" do
              let(:days_ago) { 28 }

              it { expect(exceeds?).to be_truthy }
            end
          end
        end
      end
    end
  end
end
