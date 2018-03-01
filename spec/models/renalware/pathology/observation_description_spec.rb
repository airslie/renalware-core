# frozen_string_literal: true

require "rails_helper"

module Renalware
  RSpec.describe Pathology::ObservationDescription, type: :model do
    it { is_expected.to belong_to(:measurement_unit) }

    describe "uniqueness" do
      subject { described_class.new(code: "ABC") }

      it { is_expected.to validate_uniqueness_of(:display_order) }
      it { is_expected.to validate_uniqueness_of(:display_order_letters) }
    end
  end
end
