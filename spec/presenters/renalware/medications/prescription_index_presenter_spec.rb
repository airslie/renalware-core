module Renalware
  module Medications
    describe PrescriptionIndexPresenter do
      describe "#current_prescriptions" do
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
      # rubocop:enable Metrics/MethodLength
    end
  end
end
