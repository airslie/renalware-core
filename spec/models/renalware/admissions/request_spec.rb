# frozen_string_literal: true

require "rails_helper"

describe Renalware::Admissions::Request, type: :model do
  it_behaves_like "a Paranoid model"
  it_behaves_like "an Accountable model"
  it { is_expected.to belong_to(:patient).touch(true) }
  it { is_expected.to validate_presence_of :patient_id }
  it { is_expected.to validate_presence_of :reason_id }
  it { is_expected.to validate_presence_of :priority }
  it { is_expected.to respond_to :position }
end
