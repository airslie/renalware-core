require "rails_helper"

RSpec.describe Renalware::Clinics::Appointment, type: :model do
  it { is_expected.to belong_to(:patient).touch(true) }
  it { is_expected.to validate_presence_of(:starts_at) }
  it { is_expected.to validate_presence_of(:patient) }
  it { is_expected.to validate_presence_of(:clinic) }
  it { is_expected.to validate_presence_of(:user) }
end
