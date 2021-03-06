# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe PD::Patient, type: :model do
    it { is_expected.to have_many(:pet_results) }
    it { is_expected.to have_many(:adequacy_results) }
  end
end
