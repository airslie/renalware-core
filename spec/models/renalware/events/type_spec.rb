# frozen_string_literal: true

require "rails_helper"

module Renalware::Events
  describe Type, type: :model do
    it_behaves_like "a Paranoid model"
    it { is_expected.to belong_to(:category) }

    describe "validation" do
      it :aggregate_failures do
        is_expected.to validate_presence_of :name
        is_expected.to respond_to(:event_class_name)
      end

      describe "uniqueness" do
        subject { Type.new(name: "X") }

        it { is_expected.to validate_uniqueness_of :name }
      end

      describe "#event_class_name" do
        it "returns the correct event_class_name if one provided" do
          expect(Type.new(event_class_name: "SomeClass").event_class_name).to eq("SomeClass")
        end

        it "returns the the default event_class_name done provided" do
          expect(Type.new.event_class_name).to eq(Type::DEFAULT_EVENT_CLASS_NAME)
        end
      end

      describe "#visible" do
        it "returns only types which are not hidden" do
          _hidden_event = create(:event_type, name: "A", hidden: true)
          visible_event = create(:event_type, name: "B", hidden: false)

          types = described_class.visible

          expect(types).to eq([visible_event])
        end
      end
    end
  end
end
