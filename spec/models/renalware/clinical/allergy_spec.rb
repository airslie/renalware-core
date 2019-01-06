# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinical::Allergy, type: :model do
  it_behaves_like "a Paranoid model"
  it_behaves_like "an Accountable model"
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :recorded_at }
  it { is_expected.to belong_to(:patient).touch(true) }
end
