module Renalware
  module Medications
    describe PrescriptionIndexPresenter do
      describe "#current_prescriptions" do
        it "includes standard, HD, and outpatient current prescriptions" do
          patient = create(:patient)
          standard = create(:prescription, patient:, drug: create(:drug, name: "A standard drug"))
          hd = create(
            :prescription,
            patient:,
            drug: create(:drug, name: "B HD drug"),
            administer_on_hd: true
          )
          outpatient = create(
            :prescription,
            patient:,
            drug: create(:drug, name: "C outpatient drug"),
            give_as_outpatient: true
          )

          prescriptions = described_class.new(patient:, params: {}).current_prescriptions

          expect(prescriptions.map(&:id)).to contain_exactly(standard.id, hd.id, outpatient.id)
        end

        it "preloads administered dose counts for the collection" do
          patient = create(:patient)
          prescription1 = create(
            :prescription,
            patient:,
            administer_on_hd: true,
            fixed_number_of_doses: 5,
            prescribed_on: 1.week.ago
          )
          prescription2 = create(
            :prescription,
            patient:,
            administer_on_hd: true,
            fixed_number_of_doses: 5,
            prescribed_on: 1.week.ago
          )
          create_list(:hd_prescription_administration, 2, prescription: prescription1)
          create(:hd_prescription_administration, prescription: prescription2)

          allow_grouped_count_query_for(prescription1, prescription2)

          progress = described_class
            .new(patient:, params: {})
            .current_prescriptions
            .map(&:fixed_dose_progress)

          expect(progress).to match_array(%w(2/5 1/5))
          expect(HD::PrescriptionAdministration)
            .to have_received(:where)
            .with(
              prescription_id: contain_exactly(prescription1.id, prescription2.id),
              administered: true
            )
            .once
        end

        it "preloads outpatient administered dose counts for outpatient prescriptions" do
          patient = create(:patient)
          prescription1 = create(
            :prescription,
            patient:,
            give_as_outpatient: true,
            fixed_number_of_doses: 5,
            prescribed_on: 1.week.ago
          )
          prescription2 = create(
            :prescription,
            patient:,
            give_as_outpatient: true,
            fixed_number_of_doses: 5,
            prescribed_on: 1.week.ago
          )
          create_list(:outpatient_prescription_administration, 2, prescription: prescription1)
          create(:outpatient_prescription_administration, prescription: prescription2)

          allow_grouped_outpatient_count_query_for(prescription1, prescription2)

          progress = described_class
            .new(patient:, params: {})
            .current_prescriptions
            .map(&:fixed_dose_progress)

          expect(progress).to match_array(%w(2/5 1/5))
          expect(OutpatientPrescriptionAdministration)
            .to have_received(:where)
            .with(
              prescription_id: contain_exactly(prescription1.id, prescription2.id),
              administered: true
            )
            .once
        end
      end

      describe "#current_standard_prescriptions" do
        it "includes only current prescriptions that are not HD or outpatient prescriptions" do
          patient = create(:patient)
          standard = create(:prescription, patient:, drug: create(:drug, name: "A standard drug"))
          create(
            :prescription,
            patient:,
            drug: create(:drug, name: "B HD drug"),
            administer_on_hd: true
          )
          create(
            :prescription,
            patient:,
            drug: create(:drug, name: "C outpatient drug"),
            give_as_outpatient: true
          )

          prescriptions = described_class.new(patient:, params: {}).current_standard_prescriptions

          expect(prescriptions.map(&:id)).to contain_exactly(standard.id)
        end
      end

      describe "#current_hd_prescriptions" do
        it "includes only current HD prescriptions" do
          patient = create(:patient)
          create(:prescription, patient:, drug: create(:drug, name: "A standard drug"))
          hd = create(
            :prescription,
            patient:,
            drug: create(:drug, name: "B HD drug"),
            administer_on_hd: true
          )
          create(
            :prescription,
            patient:,
            drug: create(:drug, name: "C outpatient drug"),
            give_as_outpatient: true
          )

          prescriptions = described_class.new(patient:, params: {}).current_hd_prescriptions

          expect(prescriptions.map(&:id)).to contain_exactly(hd.id)
        end
      end

      describe "#current_outpatient_prescriptions" do
        it "includes only current outpatient prescriptions" do
          patient = create(:patient)
          create(:prescription, patient:, drug: create(:drug, name: "A standard drug"))
          create(
            :prescription,
            patient:,
            drug: create(:drug, name: "B HD drug"),
            administer_on_hd: true
          )
          outpatient = create(
            :prescription,
            patient:,
            drug: create(:drug, name: "C outpatient drug"),
            give_as_outpatient: true
          )

          prescriptions = described_class.new(patient:, params: {}).current_outpatient_prescriptions

          expect(prescriptions.map(&:id)).to contain_exactly(outpatient.id)
        end
      end

      # rubocop:disable Metrics/MethodLength
      def allow_grouped_count_query_for(*prescriptions)
        prescription_ids = prescriptions.map(&:id)
        relation = HD::PrescriptionAdministration
          .where(prescription_id: prescription_ids, administered: true)
        allow(HD::PrescriptionAdministration)
          .to receive(:where)
          .and_call_original
        allow(HD::PrescriptionAdministration)
          .to receive(:where)
          .with(
            prescription_id: match_array(prescription_ids),
            administered: true
          )
          .and_return(relation)
      end

      def allow_grouped_outpatient_count_query_for(*prescriptions)
        prescription_ids = prescriptions.map(&:id)
        relation = OutpatientPrescriptionAdministration
          .where(prescription_id: prescription_ids, administered: true)
        allow(OutpatientPrescriptionAdministration)
          .to receive(:where)
          .and_call_original
        allow(OutpatientPrescriptionAdministration)
          .to receive(:where)
          .with(
            prescription_id: match_array(prescription_ids),
            administered: true
          )
          .and_return(relation)
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
