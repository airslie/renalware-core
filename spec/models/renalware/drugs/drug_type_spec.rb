# frozen_string_literal: true

require "rails_helper"

module Renalware::Drugs
  describe Type, type: :model do
    it { is_expected.to have_many(:classifications) }
    it { is_expected.to have_many(:drugs).through(:classifications) }
  end
end
