require "rails_helper"

RSpec.describe Renalware::Hospital, type: :model do
  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:name) }
end
