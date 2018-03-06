# frozen_string_literal: true

require "rails_helper"

module Renalware
  RSpec.describe Pathology::ObservationDescription, type: :model do
    it { is_expected.to belong_to(:measurement_unit) }
  end
end
