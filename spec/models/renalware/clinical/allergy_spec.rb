require "rails_helper"

RSpec.describe Renalware::Clinical::Allergy, type: :model do
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :recorded_at }
  it { is_expected.to belong_to :patient }
  it { is_expected.to respond_to :deleted? } # check acts_as_paranoide wired up
end
