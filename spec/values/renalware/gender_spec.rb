require "rails_helper"

module Renalware
  describe Gender, type: :model do
    describe "validating the gender code" do
      it "is valid given a known code" do
        valid_gender = Gender.new("F")

        expect(valid_gender).to be_valid
      end

      it "is invalid given a unknown code" do
        valid_gender = Gender.new("X")

        expect(valid_gender).to be_invalid
        expect(valid_gender.errors[:code]).to include(/included/)
      end

      it "is invalid given a no code" do
        valid_gender = Gender.new("")

        expect(valid_gender).to be_invalid
        expect(valid_gender.errors[:code]).to include(/included/)
      end

      describe "#nhs_dictionary_number" do
        it "maps genders to the the correct NHS-defined number" do
          expect(Gender.new("NK").nhs_dictionary_number).to eq(0)
          expect(Gender.new("M").nhs_dictionary_number).to eq(1)
          expect(Gender.new("F").nhs_dictionary_number).to eq(2)
          expect(Gender.new("NS").nhs_dictionary_number).to eq(9)
        end
      end
    end
  end
end
