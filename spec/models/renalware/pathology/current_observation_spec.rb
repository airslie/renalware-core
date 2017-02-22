require "rails_helper"

module Renalware
  module Pathology
    RSpec.describe CurrentObservation do
      it { is_expected.to belong_to(:patient) }
    end
  end
end
