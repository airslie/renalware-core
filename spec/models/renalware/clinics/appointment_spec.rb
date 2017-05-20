require "rails_helper"

RSpec.describe Renalware::Clinics::Appointment, type: :model do
  it { is_expected.to belong_to(:patient).touch(true) }
end
