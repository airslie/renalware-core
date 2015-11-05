require "rails_helper"

RSpec.describe Renalware::ClinicType, type: :model do
  it { should validate_presence_of :name }
end
