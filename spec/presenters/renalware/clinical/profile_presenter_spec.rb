require "rails_helper"

describe Renalware::Clinical::ProfilePresenter do
  let(:patient) { build(:patient) }
  subject { Renalware::Clinical::ProfilePresenter.new(patient) }
  it { is_expected.to respond_to(:allergies) }
end
