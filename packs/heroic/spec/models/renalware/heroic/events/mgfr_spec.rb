# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe Events::Mgfr do
    describe "#document" do
      subject { described_class.new.document }

      it { is_expected.to validate_numericality_of(:visit_number) }
      it { is_expected.to validate_numericality_of(:uncorrected_bsa) }
    end
  end
end
