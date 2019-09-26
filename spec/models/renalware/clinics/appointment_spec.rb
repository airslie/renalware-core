# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinics::Appointment, type: :model do
  it_behaves_like "an Accountable model"
  it { is_expected.to belong_to(:patient).touch(true) }
  it { is_expected.to validate_presence_of(:starts_at) }
  it { is_expected.to validate_presence_of(:patient_id) }
  it { is_expected.to validate_presence_of(:clinic_id) }
end
