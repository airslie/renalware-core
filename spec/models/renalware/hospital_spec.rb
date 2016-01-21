require "rails_helper"

module Renalware
  RSpec.describe Hospital, type: :model do
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:name) }
  end
end
