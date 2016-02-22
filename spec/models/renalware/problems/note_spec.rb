require "rails_helper"

module Renalware::Problems
  RSpec.describe Note, type: :model do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:show_in_letter) }
  end
end
