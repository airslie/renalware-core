module Renalware
  module Letters
    module Formats::Pdf
      describe Prescriptions, type: :form do
        let(:document) { test_prawn_doc }
        let(:user) { create(:user) }
        let(:patient) { create(:letter_patient, by: user) }
        let(:letter) { instance_double(Renalware::Letters::Letter, patient:) }

        it "separates current, HD, and outpatient prescriptions" do
          create_prescription(drug_name: "::current drug::")
          create_prescription(drug_name: "::hd drug::", administer_on_hd: true)
          create_prescription(drug_name: "::outpatient drug::", give_as_outpatient: true)

          described_class.new(
            document,
            letter,
            0,
            document.cursor,
            document.bounds.width
          ).build

          text = extract_text_from_prawn_doc(document)

          expect(text).to include("Current Medications")
          expect(text).to include("Drugs to give on Haemodialysis")
          expect(text).to include("Drugs to give in Outpatients")
          expect(text).to match(
            /Current Medications.*::current drug::.*Drugs to give on Haemodialysis/m
          )
          expect(text).to match(
            /Drugs to give on Haemodialysis.*::hd drug::.*Drugs to give in Outpatients/m
          )
          expect(text).to match(
            /Drugs to give in Outpatients.*::outpatient drug::.*Recently Stopped Medications/m
          )
        end

        def create_prescription(
          drug_name:,
          administer_on_hd: false,
          give_as_outpatient: false
        )
          create(
            :prescription,
            patient:,
            drug: create(:drug, name: drug_name),
            administer_on_hd:,
            give_as_outpatient:,
            prescribed_on: "2009-01-01",
            by: user
          )
        end
      end
    end
  end
end
