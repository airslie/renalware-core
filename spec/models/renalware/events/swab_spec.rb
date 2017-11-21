require "rails_helper"

module Renalware::Events
  describe Swab, type: :model do
    describe "#document" do
      subject { Swab.new.document }

      it { is_expected.to validate_presence_of(:type) }
    end
  end
end
