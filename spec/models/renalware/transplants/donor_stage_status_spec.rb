require "rails_helper"

module Renalware
  module Transplants
    describe DonorStageStatus do
      it { is_expected.to respond_to(:created_at) }
      it { is_expected.to respond_to(:updated_at) }

      it { is_expected.to validate_presence_of :name }

      describe "validation" do
        subject { DonorStageStatus.new(name: "name") }

        it { is_expected.to validate_uniqueness_of :name }
      end
    end
  end
end
