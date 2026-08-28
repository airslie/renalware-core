module Renalware
  module Virology
    describe HepatitisCDiagnosis, type: :model do
      describe "validations" do
        it "allows an end date after the beginning of the diagnosis year" do
          diagnosis = described_class.new(
            status: :unknown,
            confirmed_on_year: 2015,
            ended_on: Date.new(2015, 1, 2)
          )

          expect(diagnosis).to be_valid
        end

        it "does not allow an end date on the first day of the diagnosis year" do
          diagnosis = described_class.new(
            confirmed_on_year: 2015,
            ended_on: Date.new(2015, 1, 1)
          )

          expect(diagnosis).not_to be_valid
          expect(diagnosis.errors[:ended_on]).to include(
            "must be after the beginning of the diagnosis year"
          )
        end

        it "does not allow an end date before the diagnosis year" do
          diagnosis = described_class.new(
            confirmed_on_year: 2015,
            ended_on: Date.new(2014, 12, 31)
          )

          expect(diagnosis).not_to be_valid
        end

        it "allows an end date when the diagnosis year is absent" do
          diagnosis = described_class.new(ended_on: Date.new(2015, 1, 2))

          expect(diagnosis).to be_valid
        end
      end

      describe "#to_s" do
        it "includes the end date when present" do
          diagnosis = described_class.new(
            status: :yes,
            confirmed_on_year: 2015,
            ended_on: Date.new(2016, 2, 3)
          )

          expect(diagnosis.to_s).to eq("Yes (2015), ended 03-Feb-2016")
        end

        it "preserves the existing display when the end date is absent" do
          diagnosis = described_class.new(status: :yes, confirmed_on_year: 2015)

          expect(diagnosis.to_s).to eq("Yes (2015)")
        end
      end
    end
  end
end
