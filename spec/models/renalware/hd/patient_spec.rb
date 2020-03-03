# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe HD::Patient, type: :model do
    it { is_expected.to have_many(:prescription_administrations) }
  end
end
