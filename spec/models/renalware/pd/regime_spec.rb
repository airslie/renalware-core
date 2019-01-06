# frozen_string_literal: true

require "rails_helper"
require "./spec/support/login_macros"

module Renalware
  module PD
    describe Regime, type: :model do
      describe "validations" do
        it { is_expected.to validate_presence_of :patient }
        it { is_expected.to validate_presence_of :start_date }
        it { is_expected.to validate_timeliness_of(:start_date) }
        it { is_expected.to validate_timeliness_of(:end_date) }
        it { is_expected.to validate_presence_of :treatment }
        it { is_expected.to belong_to(:system) }
        it { is_expected.to belong_to(:patient).touch(true) }
        it { is_expected.to have_one(:termination) }
        it { is_expected.to respond_to(:assistance_type) }

        it "end_date must be after start_date" do
          regime = Regime.new(start_date: "2015-12-01", end_date: "2014-01-01")
          expect(regime.valid?).to eq(false)
          expect(regime.errors[:end_date].first).to match(/must be on or after/)
        end
      end
    end
  end
end
