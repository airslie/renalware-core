# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Delivery::TransferOfCare
      describe Sections::PatientAndCarerConcerns do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("1052941000000107") }
        it { expect(section.title).to eq("Patient and carer concerns,expectations and wishes") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # section not supported
      end
    end
  end
end
