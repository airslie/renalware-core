# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Delivery::TransferOfCare
      describe Sections::ExaminationFindings do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("715851000000102") }
        it { expect(section.title).to eq("Examination findings") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # not supported yet
      end
    end
  end
end
