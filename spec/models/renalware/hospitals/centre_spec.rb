require "rails_helper"

module Renalware::Hospitals
  RSpec.describe Centre, type: :model do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
  end
end