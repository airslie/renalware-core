require "rails_helper"

describe Renalware::Configuration do
  subject { Renalware.config }

  it "raises an error if a certain config value is not defined" do
    expect { subject.missing_value }.to raise_error(NoMethodError)
  end

  describe "#delay_after_which_a_finished_session_becomes_immutable" do
    it "defaults to 6 hours" do
      expect(subject.delay_after_which_a_finished_session_becomes_immutable).to eq(6.hours)
    end
  end
end
