# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Delivery::TransferOfCare
      describe Sections::IndividualRequirements do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("1078911000000106") }
        it { expect(section.title).to eq("Individual requirements") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # section not supported
      end
    end
  end
end
