# frozen_string_literal: true

require "rails_helper"

module Renalware
  RSpec.describe LowClearance::ModalityDescription do
    it { is_expected.to respond_to(:to_sym) }
  end
end
