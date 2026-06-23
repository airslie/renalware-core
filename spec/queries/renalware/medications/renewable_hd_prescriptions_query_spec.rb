module Renalware::Medications
  describe RenewableHDPrescriptionsQuery do
    let(:user) { create(:user) }
    let(:patient) { create(:patient, :minimal, by: user) }
    let(:yesterday) { 1.day.ago.end_of_day - 1.minute }
    let(:today) { 1.day.ago.end_of_day + 1.minute }

    # rubocop:disable Metrics/MethodLength
    def create_prescription(hd:, from:, to: nil, fixed_number_of_doses: nil)
      prescription = create(
        :prescription,
        patient:,
        administer_on_hd: hd,
        prescribed_on: from,
        fixed_number_of_doses:,
        by: user
      )
      if to.present?
        create(
          :prescription_termination,
          prescription:,
          terminated_on: to,
          by: user
        )
      end
      prescription
    end
    # rubocop:enable Metrics/MethodLength

    context "when prescription is not Give On HD, ignores all" do
      subject(:prescriptions) { described_class.new(patient:).call }

      context "when prescribed_on is on or after today" do
        it "ignores prescriptions with no future termination" do
          create_prescription(hd: false, from: 1.week.ago, to: nil)
          create_prescription(hd: false, from: 1.week.ago, to: 1.day.ago)
          create_prescription(hd: false, from: 1.week.ago, to: today)
          create_prescription(hd: false, from: 1.week.ago, to: 1.week.from_now)
          create_prescription(hd: false, from: today, to: 1.week.from_now)
          pres = create_prescription(hd: false, from: 1.week.from_now, to: 2.weeks.from_now)

          expect(pres.administer_on_hd).to be false # sanity check
          expect(described_class.new(patient:).call).to be_empty
        end
      end
    end

    context "when prescription is Give On HD" do
      it "finds HD prescriptions prescribed before today, when they have no termination" do
        pres = create_prescription(hd: true, from: yesterday, to: nil)

        expect(described_class.new(patient:).call).to eq [pres]
      end

      it "ignores prescriptions with a fixed number of doses" do
        create_prescription(hd: true, from: yesterday, to: nil, fixed_number_of_doses: 1)
        create_prescription(hd: true, from: yesterday, to: nil, fixed_number_of_doses: 2)
        pres = create_prescription(hd: true, from: yesterday, to: nil)

        expect(described_class.new(patient:).call).to eq [pres]
      end

      it "finds HD prescriptions with a future termination, prescribed before today" do
        pres = create_prescription(hd: true, from: yesterday, to: 1.week.from_now)

        expect(described_class.new(patient:).call).to eq [pres]
      end

      it "ignores prescriptions prescribed before today but terminated today" do
        create_prescription(hd: true, from: yesterday, to: today)

        expect(described_class.new(patient:).call).to be_empty
      end

      it "ignores prescriptions prescribed before today and terminated before today" do
        create_prescription(hd: true, from: 1.week.ago, to: 1.day.ago)

        expect(described_class.new(patient:).call).to be_empty
      end

      it "ignores one fixed dose prescriptions" do
        create_prescription(hd: true, fixed_number_of_doses: 1, from: 1.week.ago, to: 1.day.ago)
        create_prescription(hd: true, fixed_number_of_doses: 1, from: 1.week.ago, to: today)
        create_prescription(
          hd: true,
          fixed_number_of_doses: 1,
          from: 1.week.ago,
          to: 1.week.from_now
        )
        create_prescription(hd: true, fixed_number_of_doses: 1, from: today, to: 1.week.from_now)
        create_prescription(
          hd: true,
          fixed_number_of_doses: 1,
          from: 1.week.from_now,
          to: 2.weeks.from_now
        )

        expect(described_class.new(patient:).call).to be_empty
      end
    end
  end
end
