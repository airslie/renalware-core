require "rails_helper"

module Renalware
  RSpec.describe Renal::LowClearance::ModalityDescription do
    it { is_expected.to respond_to(:to_sym) }
  end
end
