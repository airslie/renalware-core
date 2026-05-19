# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe Research::Study do
    describe "#document" do
      subject { described_class.new.document }
    end
  end
end
