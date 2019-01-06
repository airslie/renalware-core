# frozen_string_literal: true

require "rails_helper"

module Renalware::HD
  describe Dialyser, type: :model do
    it { is_expected.to validate_presence_of(:group) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:membrane_surface_area) }
    it { is_expected.to validate_numericality_of(:membrane_surface_area_coefficient_k0a) }
  end
end
