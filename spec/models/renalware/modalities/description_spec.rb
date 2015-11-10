require "rails_helper"

module Renalware
  RSpec.describe Modalities::Description, type: :model do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
  end
end
