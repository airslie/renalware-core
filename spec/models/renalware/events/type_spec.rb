require "rails_helper"

module Renalware::Events
  describe Type, type: :model do
    describe "validation" do
      it { should validate_presence_of :name }
      it { is_expected.to respond_to(:event_class_name) }

      describe "uniqueness" do
        subject { Type.new(name: "X") }
        it { should validate_uniqueness_of :name }
      end

      describe "#event_class_name" do
        it "returns the correct event_class_name if one provided" do
          expect(Type.new(event_class_name: "SomeClass").event_class_name).to eq("SomeClass")
        end

        it "returns the the default event_class_name done provided" do
          expect(Type.new.event_class_name).to eq(Type::DEFAULT_EVENT_CLASS_NAME)
        end
      end
    end
  end
end
