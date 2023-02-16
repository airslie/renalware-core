# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Delivery::TransferOfCare
      describe Sections::ReferrerDetails do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("1052891000000108") }
        it { expect(section.title).to eq("Referrer details") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # section not supported
      end
    end
  end
end
