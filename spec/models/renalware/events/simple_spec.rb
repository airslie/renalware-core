require "rails_helper"

module Renalware::Events
  describe Simple, type: :model do
    # See Event for validation specs etc
    it { is_expected.to validate_presence_of(:description) }
  end
end
