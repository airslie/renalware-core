require "rails_helper"

module Renalware
  RSpec.describe Modalities::Description, type: :model do
    it { is_expected.to validate_presence_of :name }

    describe "#validation" do
      subject{ described_class.new(name: "P") }

      it { is_expected.to validate_uniqueness_of :name }
    end
  end
end
