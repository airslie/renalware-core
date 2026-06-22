module Renalware
  module Medications
    describe PrescriptionPresenter do
      let(:instance) { described_class.new(prescription) }
      let(:user1) {
        create(:user, password: "Renalware123!", password_confirmation: "Renalware123!")
      }
      let(:user2) {
        create(:user, password: "Renalware123!", password_confirmation: "Renalware123!")
      }

      describe "#frequency" do
        let(:prescription) { Prescription.new(frequency: "test", frequency_comment: "abc") }

        subject { instance.frequency }

        before do
          allow(Drugs::Frequency).to receive(:title_for_name).with("test").and_return("TEST")
        end

        it { is_expected.to eq "TEST abc" }
      end

      describe "#to_s" do
        it "returns a string as close as possible to NHS guidelines" do
          drug = instance_double(Drugs::Drug, name: "Drug X", to_s: "Drug X")
          unit_of_measure = instance_double(Drugs::UnitOfMeasure, name: "mg")
          prescription = instance_double(
            Prescription,
            drug:,
            dose_amount: "10",
            unit_of_measure:,
            medication_route: instance_double(MedicationRoute, name: "PO", other?: false),
            frequency: "nocte",
            frequency_comment: "abc",
            drug_name: "Drug X"
          )
          presenter = described_class.new(prescription)

          expect(presenter.to_s).to eq("Drug X - DOSE 10 mg - PO - nocte abc")
        end
      end

      describe "#last_given_or_due_date_with_indicator" do
        context "when hd and one fixed dose and not yet given" do
          it "displays date with suffix (D) meaning due" do
            prescription = Prescription.new(
              administer_on_hd: true,
              fixed_number_of_doses: 1,
              prescribed_on: "2020-01-01"
            )

            expect(described_class.new(prescription).last_given_or_due_date_with_indicator)
              .to eq("01-Jan-2020 (D)")
          end
        end

        context "when hd and not fixed dose and not yet given" do
          it "displays nothing" do
            prescription = Prescription.new(
              administer_on_hd: true,
              prescribed_on: "2020-01-01",
              patient: build(:patient)
            )

            expect(described_class.new(prescription).last_given_or_due_date_with_indicator)
              .to be_blank
          end
        end

        context "when hd and not fixed dose and has been given before" do
          it "displays date with suffix (L) meaning Last Given" do
            prescription = create(
              :prescription,
              administer_on_hd: true,
              prescribed_on: "2020-01-01"
            )
            HD::PrescriptionAdministration.create!(
              prescription:,
              administered: true,
              administered_by: user1,
              witnessed_by: user2,
              administered_by_password: "Renalware123!",
              witnessed_by_password: "Renalware123!",
              recorded_on: "2021-01-01",
              by: user1
            )

            expect(described_class.new(prescription).last_given_or_due_date_with_indicator)
              .to be_blank
          end
        end
      end

      describe "#fixed_dose_progress" do
        it "uses an injected administered doses count when supplied" do
          prescription = build(
            :prescription,
            administer_on_hd: true,
            fixed_number_of_doses: 5
          )
          allow(HD::PrescriptionAdministration).to receive(:where)

          expect(
            described_class.new(
              prescription,
              administered_doses_count: 3
            ).fixed_dose_progress
          ).to eq("3/5")
          expect(HD::PrescriptionAdministration).not_to have_received(:where)
        end

        it "returns administered doses over fixed number of doses" do
          prescription = create(
            :prescription,
            administer_on_hd: true,
            fixed_number_of_doses: 5
          )
          create_list(:hd_prescription_administration, 3, prescription:)

          expect(described_class.new(prescription).fixed_dose_progress).to eq("3/5")
        end

        it "does not count soft-deleted administrations" do
          prescription = create(
            :prescription,
            administer_on_hd: true,
            fixed_number_of_doses: 5
          )
          create(:hd_prescription_administration, prescription:).destroy!
          create_list(:hd_prescription_administration, 2, prescription:)

          expect(described_class.new(prescription).fixed_dose_progress).to eq("2/5")
        end

        it "returns nil when no fixed number of doses is set" do
          prescription = build(:prescription, fixed_number_of_doses: nil)

          expect(described_class.new(prescription).fixed_dose_progress).to be_nil
        end
      end
    end
  end
end
