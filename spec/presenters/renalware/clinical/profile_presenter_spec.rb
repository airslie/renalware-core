# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinical::ProfilePresenter do
  subject { described_class.new(patient: patient, params: {}) }

  let(:patient) { build(:patient) }

  it { is_expected.to respond_to(:allergies) }
  it { is_expected.to respond_to(:swabs) }
end
