# frozen_string_literal: true

require "rails_helper"

module Renalware::Drugs
  describe Type do
    describe "#active_drugs" do
      subject { described_class.new.active_drugs }
      it { is_expected.to eq [] }
    end
  end
end
