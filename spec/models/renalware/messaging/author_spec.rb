require "rails_helper"

module Renalware::Messaging
  describe Author, type: :model do
    it { is_expected.to have_many(:messages) }
  end
end
