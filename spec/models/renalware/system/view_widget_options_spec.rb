module Renalware
  module System
    describe ViewWidgetOptions do
      it { is_expected.to validate_numericality_of(:max_rows).only_integer.is_greater_than(0) }
      it { is_expected.to validate_inclusion_of(:order_direction).in_array(%w(asc desc)) }

      describe "#scoped_to_patient?" do
        it "is true when a patient id column is configured" do
          options = described_class.new(patient_id_column: "patient_id")

          expect(options).to be_scoped_to_patient
        end
      end

      describe "#visible_in_slot?" do
        it "checks configured slot names" do
          options = described_class.new(slots: ["hd_dashboard:right_column"])

          expect(options).to be_visible_in_slot("hd_dashboard:right_column")
          expect(options).not_to be_visible_in_slot("patient_summary:left_column")
        end
      end
    end
  end
end
