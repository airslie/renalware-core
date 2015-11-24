require "rails_helper"

shared_examples_for "Personable" do

  subject { described_class }

  describe "validations" do
    before do
      @instance = subject.new
    end
    it "requires the presence of first_name" do
      expect(@instance.valid?).to be false
      expect(@instance.errors[:given_name]).not_to be_empty
    end
    it "requires the presence of last_name" do
      expect(@instance.valid?).to be false
      expect(@instance.errors[:family_name]).not_to be_empty
    end
  end

  describe "to_s" do
    let(:instance) { subject.new(given_name: "Aneurin", family_name: "Bevan") }
    it "accepts the :full_name format" do
      expect(instance.to_s(:full_name)).to eq("Aneurin Bevan")
    end
    it "accepts the :reversed_full_name format" do
      expect(instance.to_s(:reversed_full_name)).to eq("Bevan, Aneurin")
    end
    it "defaults to Class#to_s" do
      expect(instance.to_s).to eq(instance.orig_to_s)
    end
  end
end
