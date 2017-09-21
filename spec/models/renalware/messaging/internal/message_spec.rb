require "rails_helper"

module Renalware::Messaging::Internal
  describe Message, type: :model do
    it "has the correct class" do
      expect(subject.class).to eq(Renalware::Messaging::Internal::Message)
    end
  end
end
