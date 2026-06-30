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
              prescription:,
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
              prescription:,
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
              prescription:,
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

        context "when the prescription has a fixed number of doses" do
          let(:prescription) do
            create(
              :prescription,
              give_as_outpatient: true,
              fixed_number_of_doses: 2
            )
          end

          before { create(:user, :system) }

          it "terminates once the fixed number of administered doses is reached" do
            create_administration(administered: true)

            expect(prescription.reload.termination).to be_nil

            expect {
              create_administration(administered: true)
            }.to change(PrescriptionTermination, :count).by(1)
              .and change(prescription, :updated_at)

            expect(prescription.reload.termination).to have_attributes(
              terminated_on: Time.zone.today,
              notes: "Prescription automatically terminated after 2 administered doses",
              created_by: SystemUser.find
            )
          end

          it "counts administrations saved for witnessing later" do
            create_administration(administered: true)

            expect {
              create_administration(administered: true, skip_witness_validation: true)
            }.to change(PrescriptionTermination, :count).by(1)
          end

          it "does not count administrations where the drug was not administered" do
            create_administration(administered: false)
            create_administration(administered: true)

            expect(prescription.reload.termination).to be_nil
          end

          it "does not count soft-deleted administrations" do
            create_administration(administered: true).destroy!
            create_administration(administered: true)

            expect(prescription.reload.termination).to be_nil
          end

          it "updates an existing future termination to terminate immediately" do
            future_termination_date = 14.days.since
            prescription.build_termination(
              terminated_on: future_termination_date,
              by: administrator
            ).save!

            2.times { create_administration(administered: true) }

            expect(prescription.reload.termination).to have_attributes(
              terminated_on: Time.zone.today,
              updated_by: SystemUser.find,
              created_by: SystemUser.find
            )
          end
        end
      end

      def create_administration(administered:, skip_witness_validation: false)
        described_class.create!(
          administration_attributes(
            administered:,
            skip_witness_validation:
          )
        )
      end

      def administration_attributes(administered:, skip_witness_validation:)
        attributes = {
          prescription:,
          patient: prescription.patient,
          recorded_on: Time.zone.today,
          administered:,
          by: administrator
        }

        attributes.merge!(administered_attributes(skip_witness_validation)) if administered

        attributes
      end

      def administered_attributes(skip_witness_validation)
        {
          administered_by: administrator,
          administered_by_password: "admin-password",
          witnessed_by: witness,
          witnessed_by_password: "witness-password",
          skip_witness_validation:
        }
      end
    end
  end
end
