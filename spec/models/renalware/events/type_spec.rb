require "rails_helper"

module Renalware::Events
  describe Type, type: :model do
    describe "validation" do
      it { should validate_presence_of :name }

      describe "uniqueness" do
        subject { Type.new(name: "X") }
        it { should validate_uniqueness_of :name }
      end
    end
  end
end
