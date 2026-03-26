module Renalware
  module Medications
    describe OutpatientPrescriptionAdministration do
      subject(:administration) { described_class.new }

      let(:administrator) { create(:user, password: "admin-password") }
      let(:witness) { create(:user, password: "witness-password") }

      it_behaves_like "an Accountable model"

      describe "validations" do
        it do
          is_expected.to validate_presence_of(:patient)
          is_expected.to validate_presence_of(:recorded_on)
          is_expected.to validate_presence_of(:prescription)
        end
      end

      describe "#save" do
        let(:prescription) { create(:prescription, give_as_outpatient: true) }

        context "when the drug was not administered" do
          it "does not require administrator or witness credentials" do
            administration = described_class.new(
              prescription: prescription,
              patient: prescription.patient,
              recorded_on: Date.current,
              administered: false
            )

            expect(administration).to be_valid
          end
        end

        context "when saving and witnessing later" do
          it "authorises the administering nurse only" do
            administration = described_class.new(
              prescription: prescription,
              patient: prescription.patient,
              recorded_on: Date.current,
              administered: true,
              administered_by: administrator,
              administered_by_password: "admin-password",
              skip_witness_validation: true
            )

            administration.validate

            expect(administration).to be_valid
            expect(administration.administrator_authorised).to be(true)
            expect(administration.witness_authorised).to be(false)
            expect(administration.signed_off_at).to be_nil
          end
        end

        context "when both parties sign off" do
          it "marks the administration as signed off" do
            administration = described_class.new(
              prescription: prescription,
              patient: prescription.patient,
              recorded_on: Date.current,
              administered: true,
              administered_by: administrator,
              administered_by_password: "admin-password",
              witnessed_by: witness,
              witnessed_by_password: "witness-password"
            )

            administration.validate

            expect(administration).to be_valid
            expect(administration.signed_off_at).to be_present
          end
        end

        context "when the prescription is not flagged for outpatient administration" do
          it "is invalid" do
            prescription = create(:prescription, give_as_outpatient: false)
            administration = described_class.new(
              prescription:,
              patient: prescription.patient,
              recorded_on: Date.current,
              administered: false
            )

            administration.validate

            expect(administration.errors[:prescription]).to include(
              "must have give_as_outpatient enabled"
            )
          end
        end
      end
    end
  end
end
