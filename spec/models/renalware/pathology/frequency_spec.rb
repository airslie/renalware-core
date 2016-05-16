require "rails_helper"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        describe Once do
          describe ".exceeds?" do
            subject { Once.exceeds?(1) }

            it { is_expected.to eq(false) }
          end
        end

        describe Always do
          describe ".exceeds?" do
            subject { Always.exceeds?(1) }

            it { is_expected.to eq(true) }
          end
        end

        describe Weekly do
          describe ".exceeds?" do
            context "given the days ago is 6" do
              let(:days_ago) { 6 }

              subject { Weekly.exceeds?(days_ago) }

              it { is_expected.to eq(false) }
            end

            context "given the days ago is 7" do
              let(:days_ago) { 7 }

              subject { Weekly.exceeds?(days_ago) }

              it { is_expected.to eq(true) }
            end
          end
        end

        describe Monthly do
          describe ".exceeds?" do
            context "given the days ago is 27" do
              let(:days_ago) { 27 }

              subject { Monthly.exceeds?(days_ago) }

              it { is_expected.to eq(false) }
            end

            context "given the days ago is 28" do
              let(:days_ago) { 28 }

              subject { Monthly.exceeds?(days_ago) }

              it { is_expected.to eq(true) }
            end
          end
        end
      end
    end
  end
end
