require "rails_helper"

RSpec.describe Renalware::Clinic, type: :model do
  it { should validate_presence_of :name }
end
