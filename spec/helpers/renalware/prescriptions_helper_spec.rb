require "rails_helper"

module Renalware
  RSpec.describe PrescriptionsHelper, type: :helper do
    before do
      @patient = FactoryGirl.create(:patient)
      @med_route = FactoryGirl.create(:medication_route)
      @blue_pill = FactoryGirl.create(:drug)
      @amoxicillin = FactoryGirl.create(:drug, name: "Amoxicillin")
      @penicillin = FactoryGirl.create(:drug, name: "Penicillin")
      @invalid_patient_med = FactoryGirl.build(
                              :prescription,
                              patient: @patient,
                              drug: nil,
                              dose: nil,
                              medication_route_id: nil,
                              frequency: nil,
                              prescribed_on: nil,
                              provider: nil)

      @valid_patient_med = FactoryGirl.build(
                            :prescription,
                            patient: @patient,
                            treatable: @patient,
                            drug: @amoxicillin,
                            dose: "23mg",
                            medication_route: @med_route,
                            frequency: "PID",
                            prescribed_on: "02/10/2014",
                            provider: 0)
    end

    describe "drug_name" do
      context "drug present" do
        it "should return name" do
          patient_prescription = FactoryGirl.build_stubbed(
            :prescription,
            patient: @patient,
            drug: @blue_pill
            )

          expect(drug_name(patient_prescription)).to eq(patient_prescription.drug.name)
        end
      end

      context "drug not present" do
        it "should not return name" do
          patient_prescription = FactoryGirl.build_stubbed(
            :prescription,
            patient: @patient,
            drug: nil
            )

          expect(drug_name(patient_prescription)).to eq(nil)
        end
      end
    end

    describe "highlight_validation_fail" do
      context "with errors" do
        it "should apply hightlight" do
          @invalid_patient_med.save
          expect(highlight_validation_fail(@invalid_patient_med, :drug)).to eq("field_with_errors")
        end
      end

      context "with no errors" do
        it "should not apply highlight" do
          @valid_patient_med.save
          expect(highlight_validation_fail(@valid_patient_med, :drug)).to eq(nil)
        end
      end
    end

    describe "validation_fail" do
      context "with errors" do
        it "should apply class 'show-form'" do
          @invalid_patient_med.save
          expect(validation_fail(@invalid_patient_med)).to eq("show-form")
        end
      end

      context "with no errors" do
        it "should apply class 'content'" do
          @valid_patient_med.save
          expect(validation_fail(@valid_patient_med)).to eq("content")
        end
      end
    end

    describe "default_provider" do
      before do
        @gp = Prescription.providers.keys[0]
        @hospital = Prescription.providers.keys[1]
      end

      context "is gp" do
        it "should return 'checked'" do
          expect(default_provider(@gp)).to eq("checked")
        end
      end

      context "is not gp" do
        it "should return nil" do
          expect(default_provider(@hospital)).to eq(nil)
        end
      end
    end

  end
end
