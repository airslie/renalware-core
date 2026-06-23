describe Renalware::Medications::OutpatientPrescriptionAdministrationsQuery do
  describe "#call" do
    subject(:query) { described_class.new(prescription:).call(limit: 10) }

    context "when the prescription has never been administered as an outpatient" do
      let(:prescription) { create(:prescription, give_as_outpatient: true) }

      it { is_expected.to be_empty }
    end

    context "when the prescription was recorded as administered multiple times" do
      let(:prescription) { create(:prescription, give_as_outpatient: true) }

      it "returns the most recent rows first" do
        administrations = [
          create(
            :outpatient_prescription_administration,
            prescription:,
            patient: prescription.patient,
            recorded_on: 1.month.ago
          ),
          create(
            :outpatient_prescription_administration,
            prescription:,
            patient: prescription.patient,
            recorded_on: 1.day.ago
          ),
          create(
            :outpatient_prescription_administration,
            prescription:,
            patient: prescription.patient,
            recorded_on: 1.day.ago
          )
        ]

        expect(query).to eq([administrations[2], administrations[1], administrations[0]])
      end
    end

    context "when the administration record was marked as not administered" do
      let(:prescription) { create(:prescription, give_as_outpatient: true) }

      it "does not return the record" do
        create(
          :outpatient_prescription_administration,
          prescription:,
          patient: prescription.patient,
          administered: false
        )

        expect(query).to be_empty
      end
    end
  end
end
