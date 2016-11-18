require "rails_helper"
require "./spec/support/login_macros"

module Renalware
  module PD
    RSpec.describe Regime, type: :model do
      context "validations" do
        it { should validate_presence_of :patient }
        it { should validate_presence_of :start_date }
        it { should validate_presence_of :treatment }
        it do
          should validate_inclusion_of(:delivery_interval)
                .in_array(Regime::VALID_RANGES.delivery_intervals)
        end
      end
    end
  end
end
