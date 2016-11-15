require "rails_helper"
require "./spec/support/login_macros"

module Renalware
  RSpec.describe PD::Regime, type: :model do
    context "validations" do
      it { should validate_presence_of :patient }
      it { should validate_presence_of :start_date }
      it { should validate_presence_of :treatment }
    end
  end
end
