# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Admissions::ConsultSummaryPart do
    subject(:summary_part) { described_class.new(patient) }

    let(:patient) { Patient.new }

    it { is_expected.to respond_to(:consults) }
    it { is_expected.to respond_to(:consults_count) }
    it { is_expected.to respond_to(:to_partial_path) }
    it { is_expected.to respond_to(:cache_key) }
  end
end
