require "rails_helper"

module Renalware
  module Transplants
    describe DonorStagePosition do
      it { is_expected.to respond_to(:created_at) }
      it { is_expected.to respond_to(:updated_at) }

      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :position }

      describe "validation" do
        subject { DonorStagePosition.new(name: "name", position: "position") }
        it { is_expected.to validate_uniqueness_of :name }
      end
    end
  end
end
