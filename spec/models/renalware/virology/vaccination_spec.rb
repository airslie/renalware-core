# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Virology::Vaccination do
    it { is_expected.to be_a(Events::Event) }
  end
end
