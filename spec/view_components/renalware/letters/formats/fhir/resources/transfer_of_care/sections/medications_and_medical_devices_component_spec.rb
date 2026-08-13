module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::MedicationsAndMedicalDevicesComponent, type: :component do
      subject(:component) { described_class.new(letter) }

      let(:user) { create(:user) }
      let(:patient) { create(:letter_patient, by: user) }
      let(:default_drug) { create(:drug, name: "::drug name::") }
      let(:hd_drug) { create(:drug, name: "::hd drug name::") }
      let(:outpatient_drug) { create(:drug, name: "::outpatient drug name::") }
      let(:letter) { instance_double(Renalware::Letters::Letter, patient:) }

      def terminated_prescription(terminated_on:, drug: default_drug)
        create(:prescription,
               patient:,
               drug:,
               prescribed_on: "2009-01-01",
               termination: build(:prescription_termination, terminated_on:),
               by: user)
      end

      def current_prescription(
        prescribed_on: "2009-01-01",
        drug: default_drug,
        administer_on_hd: false,
        give_as_outpatient: false
      )
        create(:prescription,
               patient:,
               drug:,
               prescribed_on:,
               updated_at: prescribed_on,
               created_at: prescribed_on,
               administer_on_hd:,
               give_as_outpatient:,
               by: user)
      end

      it "displays current prescriptions" do
        current_prescription

        render_inline(component)

        expect(page).to have_text("Current Medications")
        expect(page).to have_text("::drug name::")
        expect(page).to have_text("20 mg Oral daily GP")
        expect(page).to have_no_text("Drugs to give on Haemodialysis")
        expect(page).to have_no_text("Drugs to give in Outpatients")
        expect(page).to have_text("Recently Stopped Medications")
        expect(page).to have_text("None")
      end

      it "displays HD prescriptions" do
        current_prescription(administer_on_hd: true, drug: hd_drug)

        render_inline(component)

        expect(page).to have_text("Current Medications")
        expect(page).to have_text("None")
        expect(page).to have_text("Drugs to give on Haemodialysis")
        expect(page).to have_text("::hd drug name::")
        expect(page).to have_text("20 mg Oral daily GP")
        expect(page).to have_no_text("Drugs to give in Outpatients")
        expect(page).to have_text("Recently Stopped Medications")
        expect(page).to have_text("None")
      end

      it "displays outpatient prescriptions separately from current prescriptions" do
        current_prescription(drug: default_drug)
        current_prescription(give_as_outpatient: true, drug: outpatient_drug)

        render_inline(component)

        current_medications_table = page.first("table")
        outpatient_medications_table = page.all("table")[1]

        expect(page).to have_text("Current Medications")
        expect(current_medications_table).to have_text("::drug name::")
        expect(current_medications_table).to have_no_text("::outpatient drug name::")
        expect(outpatient_medications_table).to have_text("Drugs to give in Outpatients")
        expect(outpatient_medications_table).to have_text("::outpatient drug name::")
        expect(outpatient_medications_table).to have_text("20 mg Oral daily GP")
      end

      it "displays recently stopped prescriptions" do
        terminated_prescription(terminated_on: 2.days.ago)

        render_inline(component)

        pending "fix tests as seems to be using current datetime"

        expect(page).to have_text("Current Medications")
        expect(page).to have_text("No medications")
        expect(page).to have_no_text("Drugs to give on Haemodialysis")
        expect(page).to have_no_text("Drugs to give in Outpatients")
        expect(page).to have_text("::drug name::")
        expect(page).to have_text("20 mg Per Oral daily GP 20-Mar-2024")
        expect(page).to have_text("Recently Stopped Medications")
      end
    end
  end
end
