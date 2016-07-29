require "rails_helper"

module Renalware
  RSpec.describe Medications::PrescriptionTermination, type: :model do
    describe "validations" do
      describe "terminated_on" do
        let(:prescription) { build(:prescription, prescribed_on: "2011-01-01") }

        context "given the date is after prescribed on" do
          let(:termination) do
            build(:prescription_termination,
              terminated_on: "2012-01-01", prescription: prescription)
          end

          it { expect(termination).to be_valid }
        end

        context "given the date is before prescribed on" do
          let(:termination) do
            build(:prescription_termination,
              terminated_on: "2010-01-10", prescription: prescription)
          end

          before { termination.valid? }
          it { expect(termination.errors[:terminated_on]).to match([/after/]) }
        end
      end
    end
  end
end
