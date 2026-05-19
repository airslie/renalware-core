# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe Events::Mri do
    describe "#document" do
      subject { described_class.new.document }

      it { is_expected.to validate_numericality_of(:visit_number) }
    end
  end
end
