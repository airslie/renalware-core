# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Delivery::TransferOfCare
      describe Sections::ClinicalSummary do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("887181000000106") }
        it { expect(section.title).to eq("Clinical summary") }
        it { expect(section.render?).to be(true) }
        it { expect(section.call).not_to be_nil }
      end
    end
  end
end
