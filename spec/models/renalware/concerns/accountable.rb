require "rails_helper"

shared_examples_for "Accountable" do
  it { is_expected.to respond_to(:by=) }
  it { is_expected.to respond_to(:save_by!) }
end
