require "rails_helper"

module Renalware
  module Pathology
    module Requests
      class Frequency
        describe Once do
          subject(:frequency) { Once.new }

          describe "#observation_required?" do
            it { expect(frequency.observation_required?(1)).to be_falsey }
          end

          describe "#once?" do
            it { expect(frequency.once?).to be_truthy }
          end
        end

        describe Always do
          subject(:frequency) { Always.new }

          describe "#observation_required?" do
            it { expect(frequency.observation_required?(1)).to be_truthy }
          end

          describe "#once?" do
            it { expect(frequency.once?).to be_falsey }
          end
        end

        describe Weekly do
          subject(:frequency) { Weekly.new }

          describe "#observation_required?" do
            context "given the days ago is 6" do
              it { expect(frequency.observation_required?(6)).to be_falsey }
            end

            context "given the days ago is 7" do
              it { expect(frequency.observation_required?(7)).to be_truthy }
            end
          end

          describe "#once?" do
            it { expect(frequency.once?).to be_falsey }
          end
        end

        describe Monthly do
          subject(:frequency) { Monthly.new }

          describe "#observation_required?" do
            context "given the days ago is 27" do
              it { expect(frequency.observation_required?(27)).to be_falsey }
            end

            context "given the days ago is 28" do
              it { expect(frequency.observation_required?(28)).to be_truthy }
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
