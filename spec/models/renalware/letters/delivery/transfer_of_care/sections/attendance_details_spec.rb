# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Delivery::TransferOfCare
      describe Sections::AttendanceDetails do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("1077881000000105") }
        it { expect(section.title).to eq("Attendance details") }
        it { expect(section.render?).to be(true) }
      end
    end
  end
end
