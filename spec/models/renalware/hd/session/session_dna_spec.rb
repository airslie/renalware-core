require "rails_helper"

module Renalware
  module HD
    RSpec.describe Session::DNA, type: :model do
      it "defines a policy class" do
        expect(Session::DNA.policy_class).to eq(DNASessionPolicy)
      end
    end
  end
end
