module Renalware
  module Virology
    describe ProfileDocument, type: :model do
      subject(:document) { described_class.new }

      it :aggregate_failures do
        is_expected.to respond_to(:hiv)
        is_expected.to respond_to(:hepatitis_b)
        is_expected.to respond_to(:hepatitis_b_core_antibody)
        is_expected.to respond_to(:hepatitis_c)
        is_expected.to respond_to(:htlv)
      end

      it "uses the hepatitis C-specific diagnosis type" do
        expect(document.hepatitis_c).to be_a(HepatitisCDiagnosis)
      end

      it "loads existing hepatitis C data without an end date" do
        existing_document = described_class.new(
          hepatitis_c: { status: "yes", confirmed_on_year: 2015 }
        )

        expect(existing_document.hepatitis_c.ended_on).to be_nil
        expect(existing_document.hepatitis_c.to_s).to eq("Yes (2015)")
      end
    end
  end
end
